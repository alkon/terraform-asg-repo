# modules/ec2-instance/variables.tf

variable "key_name" {
  description = "The name for the EC2 key pair."
  type        = string
}

variable "public_key" {
  description = "The public key material for the EC2 key pair."
  type        = string
  sensitive   = true # Mark as sensitive as it contains key material
}

variable "security_group_name" {
  description = "The name for the EC2 security group."
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type (e.g., t2.micro)."
  type        = string
}

variable "name_tag" {
  description = "The 'Name' tag for the EC2 instance."
  type        = string
}