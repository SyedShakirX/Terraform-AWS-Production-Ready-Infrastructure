output "private_ec2_asg" {
  description = "Autoscaling Group ID"
  value = aws_autoscaling_group.private_ec2_asg.id
}