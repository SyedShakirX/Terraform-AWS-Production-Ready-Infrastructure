variable "vpc_cidr" {
  type = string
}

variable "internet_cidr" {
  type = string
}

variable "ec2_ports" {
  type = map(string)
}

variable "alb_ports" {
  type = map(string)
}