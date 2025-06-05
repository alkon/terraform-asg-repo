# modules/wordpress-local/variables.tf

### Defines the input variables for the WordPress module

variable "db_root_password" {
  description = "Root password for the MySQL database."
  type        = string
  sensitive   = true # Mark as sensitive to prevent showing in logs
}

variable "db_name" {
  description = "Name of the WordPress database."
  type        = string
  default     = "wordpress"
}

variable "db_user" {
  description = "Username for the WordPress database."
  type        = string
  default     = "wordpress_user"
}

variable "db_password" {
  description = "Password for the WordPress database user."
  type        = string
  sensitive   = true # Mark as sensitive
}

variable "wordpress_port" {
  description = "The host port to expose WordPress on."
  type        = number
  default     = 8000
}