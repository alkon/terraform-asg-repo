#  variables.tf at the project root

# Defines input variables for the root Terraform configuration.
# These variables control global settings or parameters for the entire project.

variable "project_prefix" {
  description = "A prefix to apply to resource names for organization and uniqueness."
  type        = string
  default     = "localdev"
}

variable "aws_region" {
  description = "The AWS region for LocalStack emulation."
  type        = string
  default     = "us-east-1"
}

variable "ssh_key_name" {
  description = "The name of the SSH key pair to be used for EC2 instances."
  type        = string
  default     = "my-local-key"
}

# Variables for AWS provider credentials (mock for LocalStack)
variable "aws_access_key" {
  description = "Access key for the AWS provider (mock for LocalStack)."
  type        = string
  default     = "mock_access_key" # Default mock access key
}

variable "aws_secret_key" {
  description = "Secret key for the AWS provider (mock for LocalStack)."
  type        = string
  sensitive   = true # Mark as sensitive even if mock, good practice
  default     = "mock_secret_key" # Default mock secret key
}