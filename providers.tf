# ~/PycharmProjects/localstack-prj/providers.tf
# Defines required Terraform providers and their configurations.

# AWS Provider Configuration for LocalStack
# This block configures the AWS provider to interact with your LocalStack instance.
provider "aws" {
  # The region for LocalStack emulation, taken from a root variable.
  region                      = var.aws_region
  # Mock credentials for LocalStack, taken from root variables.
  # While mock, using variables provides consistency if you ever need to change them.
  access_key                  = var.aws_access_key
  secret_key                  = var.aws_secret_key
  s3_use_path_style           = true              # Required for S3 in LocalStack
  skip_credentials_validation = true              # Skip validation for mock credentials
  skip_metadata_api_check     = true              # Skip metadata check
  skip_requesting_account_id  = true              # Skip account ID request

  # Define endpoints to point to your LocalStack instance.
  # These are typically hardcoded as LocalStack runs on a fixed local address.
  endpoints {
    ec2 = "http://localhost:4566"
    s3  = "http://localhost:4566"
    # Add other services as needed, e.g.:
    # sqs = "http://localhost:4566"
    # lambda = "http://localhost:4566"
    # dynamodb = "http://localhost:4566"
  }
}