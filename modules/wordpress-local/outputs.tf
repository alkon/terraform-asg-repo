# modules/wordpress-local/outputs.tf

output "wordpress_url" {
  description = "The URL to access the local WordPress instance."
  # This value is derived from the input variable 'wordpress_port'
  # which is passed into the module.
  value = "http://localhost:${var.wordpress_port}"
}