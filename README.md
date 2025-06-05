## Assignment 11: Terraform Usage
This assignment focuses on using Terraform to manage and orchestrate a local development environment.

### Task 1
- Create a t2.micro EC2 instance from an Ubuntu AMI
Note: Used `LocalStack` to **simulate** AWS service for EC2 instantiation
- Create a security group allowing SSH access and attach it to the EC2 instance

### Task 2
- Deploy a WordPress app using Docker Compose on the host machine
- **Challenge:** Connect conceptually to the emulated environment using Docker Compose

### Project Structure
```text
project root/
├── docker-compose.yaml       # Defines the LocalStack service container.
├── main.tf                   # Root entry point: Defines core Terraform settings (e.g., required providers).
├── providers.tf              # Configures the AWS provider to point to LocalStack endpoints.
├── modules.tf                # Calls and configures the custom Terraform modules.
├── variables.tf              # Defines root-level input variables for global settings.
├── outputs.tf                # Defines root-level outputs to display key deployment information.
└── modules/                  # Contains reusable Terraform modules.
    ├── ec2-instance/         # Module for emulated EC2 resources (Task 1).
    │   ├── main.tf           # Defines aws_key_pair, aws_security_group, aws_instance.
    │   ├── variables.tf      # Inputs for this module (e.g., instance type, key name).
    │   └── outputs.tf        # Outputs from this module (e.g., instance ID, security group ID).
    └── wordpress-local/      # Module for local WordPress deployment (Task 2).
        ├── main.tf           # Contains local_file (for .tpl rendering) and null_resource (for Docker Compose commands).
        ├── variables.tf      # Inputs for this module (e.g., DB passwords, WordPress port).
        ├── outputs.tf        # Outputs from this module (e.g., WordPress URL).
        └── docker-compose.yaml.tpl # Template for WordPress Docker Compose file.

```

### The role of `docker-compose.yaml` and of `docker-compose.yaml.tpl`
- `docker-compose.yaml` sits at the project root. It's single purpose to define and run the **LocalStack service** as a Docker container.
-  The Module Level Template `docker-compose.yaml.tpl` is placed at the **wordpress-local** module level.  Its purpose to define the WordPress app stack that runs on the host
-  **ec2-instance** module **doesnt** define a Docker Compose stack. It creates AWS cloud resources by making **direct** API calls to LocalStack emulator. So it has no need for Docker Compose to do this.

### Prerequisites
- Docker: For running containers (LocalStack, WordPress, MySQL)
- Docker Compose: (comes with Docker Desktop)
- AWS CLI: For interacting with AWS services (and LocalStack)
- awslocal (LocalStack CLI): A wrapper around AWS CLI for LocalStack. Install via pip install localstack-client awscli-local
- Terraform: The IaC tool

### Setup & Deployment
Note: Ensure to be in the project's root directory
- Clean Up Previous State (for fresh start)
```bash
   # Stop and remove LocalStack container and its volumes
docker compose down -v

# Clean up WordPress Docker Compose (if it was run independently or in prior setup)
# This assumes the wordpress-local module has created its docker-compose.yaml file.
cd modules/wordpress-local/
docker compose down -v
rm -f docker-compose.yaml # Remove the generated docker-compose.yaml file
cd ../.. # Go back to the project root

# Clean up all Terraform-specific local files (state, cache, logs, local key)
rm -rf .terraform/ terraform.tfstate* .terraform.lock.hcl my-local-key.pem

echo "--- Cleanup Complete ---"
```
- Start LocalStack
```bash
   docker compose up -d
   docker ps # Verify LocalStack container status (should be 'Up (healthy)')
```
- Generate SSH Key Pair
Note: Create an SSH key pair in LocalStack and save the private key locally. Terraform will then use this key pair in the **ec2-instance** module.
```bash
    # Ensure to be in the project root
    awslocal ec2 delete-key-pair --key-name my-local-key || true # Clean up if it exists
    rm -f my-local-key.pem # Remove local private key file if it exists
    awslocal ec2 create-key-pair --key-name my-local-key --query 'KeyMaterial' --output text > my-local-key.pem
    chmod 400 my-local-key.pem # Set correct permissions for the private key
    
    # Get the public key content to paste into the Terraform config
    PUBLIC_KEY_CONTENT=$(ssh-keygen -y -f my-local-key.pem)
    echo "Public Key Content to paste into modules.tf (for module 'my_app_ec2'):"
    echo "$PUBLIC_KEY_CONTENT"
```
**Important!** Manually copy the PUBLIC_KEY_CONTENT from the terminal output and paste it as the value for the public_key variable within the module "my_app_ec2" block in project/modules.tf file.

- Initialize Terraform
Download the necessary Terraform providers and set up the project
  - Note: Use `-reconfigure` flag if there were changes to providers/data sources
```bash
   terraform init -reconfigure 
```
   
- Apply Terraform Configuration
   - Note: Terraform will show a **plan** of the resources it will create/manage. Type `yes` when prompted to confirm the deployment
```bash
   terraform apply
```
- Verification:
  - Task 1: Verify LocalStack Emulated Resources
```bash  
    echo "--- Verifying EC2 Instance (API Mock) ---"
    awslocal ec2 describe-instances --filters "Name=tag:Name,Values=localdev-WebAppInstance"
    
    echo "--- Verifying Security Groups (API Mock) ---"
    awslocal ec2 describe-security-groups # Note: LocalStack CE may not list custom SGs consistently
    
    echo "--- Verifying Key Pair ---"
    awslocal ec2 describe-key-pairs --key-names my-local-key
```
- Task 2: Verify Local WordPress Deployment
```bash
   echo "--- Verifying WordPress Docker Containers ---"
    docker ps --filter "name=wordpress" --filter "name=db"
    
    echo "--- Getting WordPress Access URL ---"
    terraform output wordpress_access_url
```
 - Access WordPress in Browser, i.e., http://localhost:8080


   
