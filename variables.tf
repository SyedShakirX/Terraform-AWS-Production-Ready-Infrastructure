variable "vpc_cidr" {
  type = string
}

variable "internet_cidr" {
  type = string
}

variable "ec2_ports" {
  type = map(string)
}

variable "ssh_key" {
  type = string
}

variable "bastion_ami" {
  type = string
}

variable "bastion_type" {
  type = string
}

# We can choose a different configuration for ASG EC2 as per our requirements.

variable "asg_ec2_ami" {
  type = string
}

variable "asg_ec2_type" {
  type = string
}

variable "alb_ports" {
  type = map(string)
}

