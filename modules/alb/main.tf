#------- Creating Target Groups That Will Target The EC2 and Application Running In Them -------#
resource "aws_lb_target_group" "shakirs_target_group" {
  name     = "shakirs-app-tg"
  port     = 8080     # Port of our application
  protocol = "HTTP"
  vpc_id   = var.shakirs_vpc

  health_check {
    port     = "8080" 
    protocol = "HTTP"
    path     = "/"
  }
}

#
#
#


#------- Creating ALB In 2 Different AZ in Private Subnets -------#

resource "aws_lb" "shakirs_alb" {
  name               = "Shakirs-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_alb]
  subnets            = [var.shakirs_pub_sn_1a,var.shakirs_pub_sn_1b]

  enable_deletion_protection = false


  tags = {
    Environment = "production"
  }
}

#
#
#

#------- Creating A Listener For ALB So The Users Request Reaches The ALB & Forward To Target Groups -------#

resource "aws_lb_listener" "shakirs_http_listener" {
  load_balancer_arn = aws_lb.shakirs_alb.arn   
  port              = "80"  #This is where the user will access the ALB over internet
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.shakirs_target_group.arn  
  }
}

#
#
#

#------- Creating Autoscaling Attachment -------#

# "Target Groups are destination-based, not subnet-based. We used an autoscaling_attachment to ensure that only instances managed by my ASG are registered as targets by Target Group. This prevents the Load Balancer from trying to route traffic to unauthorized or unrelated resources within the same subnet, because just in case there might be other instances in the same private subnets"

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = var.private_ec2_asg
  lb_target_group_arn    = aws_lb_target_group.shakirs_target_group.arn
}

