# main.tf in the project root

# This file serves as the entry point or a general placeholder for the root configuration.
# All providers, module calls, variables, and outputs are in their respective files.

# Terraform Configuration Block
# Specifies the minimum required Terraform version and declares the providers
# that this configuration depends on.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use a compatible AWS provider version
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0" # For local_file resource (used in modules)
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0" # For null_resource to run local commands (used in modules)
    }
  }

  # Optional: If using remote state, configure it here (e.g., S3 backend)
  # backend "s3" {
  #   bucket = "terraform-state-bucket"
  #   key    = "localstack-project/terraform.tfstate"
  #   region = "us-east-1"
  #   endpoint = "http://localhost:4566"
  #   skip_credentials_validation = true
  #   skip_metadata_api_check     = true
  #   force_path_style            = true
  # }
}