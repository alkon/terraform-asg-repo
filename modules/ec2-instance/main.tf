# modules/ec2-instance/main.tf
# This file defines the EC2-related resources managed by this module.

# Data Source: AWS Default VPC
# Fetches information about the default VPC in the current region.
# This makes the security group explicitly tied to a VPC, which can improve reliability.
data "aws_vpc" "default" {
  default = true
}

# Resource: AWS EC2 Key Pair
# Creates an SSH key pair that can be used to access the EC2 instance.
resource "aws_key_pair" "app_key" {
  key_name   = var.key_name
  public_key = var.public_key
}

# Resource: AWS EC2 Security Group
# Defines network access rules for the EC2 instance.
# This security group allows inbound SSH traffic on port 22 from anywhere.
resource "aws_security_group" "app_sg" {
  name        = var.security_group_name
  description = "Security group for ${var.name_tag} instance"
  # Explicitly associate with the default VPC
  vpc_id      = data.aws_vpc.default.id # <-- NEW LINE

  # Ingress (inbound) rule: Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow from all IPv4 addresses
  }

  # Egress (outbound) rule: Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Removed: The tags block from the security group for simplicity
  # tags = {
  #   Name = "${var.name_tag}-sg"
  # }
}

# Resource: AWS EC2 Instance
# Launches an EC2 instance with the specified AMI, instance type,
# key pair, and security group.
resource "aws_instance" "app_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.app_key.key_name
  security_groups = [aws_security_group.app_sg.name] # Referencing the name of the SG created in this module

  tags = {
    Name = var.name_tag
  }
}