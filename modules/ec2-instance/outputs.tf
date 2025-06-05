# modules/ec2-instance/outputs.tf

output "instance_id" {
  description = "The ID of the created EC2 instance."
  value       = aws_instance.app_instance.id
}

output "security_group_id" {
  description = "The ID of the created security group."
  value       = aws_security_group.app_sg.id
}

output "key_pair_name" {
  description = "The name of the created key pair."
  value       = aws_key_pair.app_key.key_name
}