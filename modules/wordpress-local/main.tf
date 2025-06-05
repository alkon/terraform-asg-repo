# modules/wordpress-local/main.tf
# (as provided in previous responses)
resource "local_file" "wordpress_docker_compose" {
  content  = templatefile("${path.module}/docker-compose.yaml.tpl", {
    db_root_password = var.db_root_password
    db_name          = var.db_name
    db_user          = var.db_user
    db_password      = var.db_password
    wordpress_port   = var.wordpress_port
  })
  filename = "${path.module}/docker-compose.yaml"
}

resource "null_resource" "deploy_wordpress" {
  depends_on = [local_file.wordpress_docker_compose]
  provisioner "local-exec" {
    command = <<EOT
      echo "Deploying WordPress using Docker Compose..."
      cd ${path.module}
      docker compose up -d
      echo "WordPress deployment initiated. Access at http://localhost:${var.wordpress_port}"
    EOT
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      echo "Tearing down WordPress Docker Compose deployment..."
      cd ${path.module}
      docker compose down -v
      echo "WordPress deployment torn down."
    EOT
  }
}