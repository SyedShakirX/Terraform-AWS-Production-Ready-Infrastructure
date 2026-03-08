#------- Creating Security Group For Bastion Hosts -------#
resource "aws_security_group" "security_group_bastion" {
  name        = "bastion-host-sg"
  description = "Allow SSH, HTTP natively inbound traffic"
  vpc_id      = aws_vpc.shakirs_vpc.id

  dynamic "ingress" {
    for_each = var.ec2_ports
    iterator = port
    content {
      description = port.value
      from_port   = tonumber(port.key)
      to_port     = tonumber(port.key)
      protocol    = "tcp"
      cidr_blocks = [var.internet_cidr]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.internet_cidr]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Bastion Host SG"
  }
}

#
#
#

#------- Creating Least Privilege Security Groups For Private Instances -------#

resource "aws_security_group" "security_group_asg_ec2" {
  name        = "private-ec2-sg-asg"
  description = "Security group for private ASG instances"
  
  vpc_id      = aws_vpc.shakirs_vpc.id

  ingress {
    description     = "Allow SSH from ONLY Bastion Hosts"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    #~~~Security Group Referrencing For Least Privilege~~~#
    security_groups = [aws_security_group.security_group_bastion.id] 
  }

 ingress {
   description = "Allow Port 8080 ONLY From ALB"
   from_port   = 8080
   to_port     = 8080
   protocol    = "tcp"
   #~~~Security Group Referrencing For Least Privilege~~~#
   security_groups = [aws_security_group.security_group_alb.id]  ################################### Pending###########
 }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.internet_cidr]
  }

  tags = {
    Name = "Private EC2 ASG SG"
  }
}

#
#
#

#------- Creating Security Group For ALB -------#

resource "aws_security_group" "security_group_alb" {
  name        = "ELB_Security_group"
  description = "Security group for ALB"
  
  vpc_id      = aws_vpc.shakirs_vpc.id

  dynamic ingress {
    for_each = var.alb_ports
    iterator = port
      content { 
      description     = port.value
      from_port       = tonumber(port.key)
      to_port         = tonumber(port.key)
      protocol        = "tcp"
      cidr_blocks     = [var.internet_cidr]    
  }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.internet_cidr]
  }

  tags = {
    Name = "ALB SG"
  }
}
