 # outputs.tf at the project root

# From the EC2 instance module
output "ec2_instance_id" {
  description = "The ID of the emulated EC2 instance."
  value       = module.my_app_ec2.instance_id # Accessing output from the ec2-instance module
}
output "ssh_security_group_id" {
  description = "The ID of the SSH security group."
  value       = module.my_app_ec2.security_group_id # Accessing output from the ec2-instance module
}

# From the WordPress module
output "wordpress_access_url" {
  description = "The URL to access the local WordPress instance."
  value       = module.local_wordpress_app.wordpress_url # Accessing output from the wordpress-local module
}