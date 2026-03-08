output "shakirs_vpc" {
  description = "VPC ID"
  value = aws_vpc.shakirs_vpc.id
}

output "shakirs_pub_sn_1a" {
    description = "Public Subnet In 1-a AZ"
    value = aws_subnet.shakirs_pub_sn_1a.id
}

output "shakirs_pub_sn_1b" {
    description = "Public Subnet In 1-b AZ"
    value = aws_subnet.shakirs_pub_sn_1b.id
}

output "shakirs_pvt_sn_1a" {
    description = "Private Subnet In 1-a AZ"
    value = aws_subnet.shakirs_pvt_sn_1a.id
}

output "shakirs_pvt_sn_1b" {
    description = "Private Subnet In 1-b AZ"
    value = aws_subnet.shakirs_pvt_sn_1b.id
}

output "security_group_bastion" {
    description = "Security Group For Bastion Hosts"
    value = aws_security_group.security_group_bastion.id   
}

output "security_group_asg_ec2" {
    description = " Least Privilege Security Group For ASG Private EC2 Instances"
    value = aws_security_group.security_group_asg_ec2.id
}

output "security_group_alb" {
    description = " Security Group For AWS ALB"
    value = aws_security_group.security_group_alb.id
}

