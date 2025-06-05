# ~/PycharmProjects/localstack-prj/modules.tf
# Defines calls to custom Terraform modules for different parts of the infrastructure.

# Module Call: EC2 Instance Setup
# This module creates the emulated EC2 instance, security group, and key pair
# within your LocalStack environment.
module "my_app_ec2" {
  source = "./modules/ec2-instance" # Path to your ec2-instance module

  # Input variables for the ec2-instance module, sourced from root variables or hardcoded.
  name_tag            = "${var.project_prefix}-WebAppInstance" # Uses root variable 'project_prefix'
  ami_id              = "ami-df5de72bdb3b" # Example AMI ID for LocalStack
  instance_type       = "t2.micro"
  key_name            = var.ssh_key_name # Uses root variable 'ssh_key_name'

  # IMPORTANT: Replace this with the actual public key content from your my-local-key.pem
  # You can generate it with `ssh-keygen -y -f my-local-key.pem`
  public_key          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDdgblBp0C6oryeDVMXBKtcsdU3+ys9CAx2HHzeAF+FWTeKOzMx8g01Ke61XJCGlTuAEKU7tPLcfTI7GCM4h8cwn+48mYH1vXyPEF1ls644JklQOeTmo14cr7VEK7W0HuIKZEmWxgyUtAIqdUVX8nFZ/S6M0ZXzTesEhTeQawwAlAlBzGyC6EVG/9VJafc1tokj6dNlPyLiXZM0aroppB2SNZ7Nk8scqWSQJD5ma08pTPTa11TaWWi9VJEYt0CNpLrsieofa2ysjtFl+QE4TWxPIz8ePjKynoIhNUH2X+I+A9B+6zVtrEwFyjU/iJo9yW3qvFEtbFFnFea6RMJtv6r"
  security_group_name = "${var.project_prefix}-minimal-ssh-sg" # Uses root variable 'project_prefix'
}

# Module Call: Local WordPress Application Deployment
# This module orchestrates the Docker Compose deployment of WordPress directly
# on your host machine.
module "local_wordpress_app" {
  source = "./modules/wordpress-local" # Path to your wordpress-local module

  # Input variables for the wordpress-local module.
  # IMPORTANT: Change these sensitive values to strong, unique passwords!
  db_root_password = "your_strong_root_password_here" # Hardcoded for simplicity, could be a root variable
  db_name          = "my_wordpress_db"
  db_user          = "my_wordpress_user"
  db_password      = "my_strong_db_password_here"
  wordpress_port   = 8080 # Access WordPress on http://localhost:8080

  # Ensure WordPress deployment starts after the EC2 setup is "complete"
  # (even though EC2 is mocked, this establishes a logical dependency order).
  depends_on = [module.my_app_ec2]
}