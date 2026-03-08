#------- Creating Key Pairs For SSH -------#

resource "aws_key_pair" "ssh_key_pair" {
  key_name   = "ssh_key"
  public_key = var.ssh_key
}

#
#
#

#------- Creating Bastion Host In 1-a AZ -------#

resource "aws_instance" "Bastion_EC2_1a" {
  ami           = var.bastion_ami
  instance_type = var.bastion_type
  key_name               = aws_key_pair.ssh_key_pair.key_name
  subnet_id                   = var.shakirs_pub_sn_1a
  vpc_security_group_ids      = [var.security_group_bastion]
  associate_public_ip_address = true

  tags = {
    Name = "Bastion Host In 1-a AZ"
  }

}

#
#
#

#------- Creating Bastion Host In 1-b AZ -------#

resource "aws_instance" "Bastion_EC2_1b" {
  ami           = var.bastion_ami
  instance_type = var.bastion_type
  key_name               = aws_key_pair.ssh_key_pair.key_name
  subnet_id                   = var.shakirs_pub_sn_1b
  vpc_security_group_ids      = [var.security_group_bastion]
  associate_public_ip_address = true

  tags = {
    Name = "Bastion Host In 1-b AZ"
  }

}

#
#
#

#------- Creating Custom Launch Template For Auto Scaling Groups -------#

resource "aws_launch_template" "pvt_ec2_launch_template" {
  name_prefix = "shakirs_launch_template-"

  image_id = var.asg_ec2_ami

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = var.asg_ec2_type 

  key_name = aws_key_pair.ssh_key_pair.key_name


  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [var.security_group_asg_ec2]    

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Auto Scaled EC2"
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    # Update packages and install Apache for Ubuntu/Debian
    apt-get update -y
    apt-get install -y apache2
    
    # Change Apache to listen on port 8080 instead of 80
    sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf
    sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/' /etc/apache2/sites-available/000-default.conf

    # Fetch your raw HTML file from GitHub and place it in the web root
    curl -o /var/www/html/index.html https://raw.githubusercontent.com/SyedShakirX/HTML-File/main/index.html

    # Restart the service to apply the port changes, then enable it on boot
    systemctl restart apache2
    systemctl enable apache2
  EOF
  )
}

#
#
#

#------- Creating Auto Scaling Group -------#

resource "aws_autoscaling_group" "private_ec2_asg" {
  name                      = "Private_ASG_EC2"
  max_size                  = 8
  min_size                  = 4
  health_check_grace_period = 300
  health_check_type         = "ELB"  
  desired_capacity          = 5
  force_delete              = true

  launch_template {
          id = aws_launch_template.pvt_ec2_launch_template.id
          version = "$Latest"
  }

  vpc_zone_identifier       = [var.shakirs_pvt_sn_1a, var.shakirs_pvt_sn_1b]

  instance_maintenance_policy {
    min_healthy_percentage = 100   # minimumUnavailable in k8s
    max_healthy_percentage = 200   # maxSurge in k8s
  }


  tag { 
    key                 = "Source"
    value               = "ASG"
    propagate_at_launch = true
  }

  timeouts {   
    delete = "15m"
  }

}

#------- Creating Auto Scaling Policy For ASG -------#

resource "aws_autoscaling_policy" "cpu_scaling_policy" {
  name                   = "target-tracking-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.private_ec2_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0  # i.e., 50% average
  }
}

