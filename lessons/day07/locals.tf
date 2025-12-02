locals {
  # Shared tags for all resources
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    LOB         = "Engineering"
    Stage       = "Alpha"
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
  }

  # Network settings from tuple
  vpc_cidr    = var.network_config[0]
  subnet_cidr = var.network_config[1]

  # EC2 name from object
  instance_name = "${var.server_config.name}-instance"

  # Well-known ports (map)
  port_description = {
    22  = "SSH"
    80  = "HTTP"
    443 = "HTTPS"
  }
}
