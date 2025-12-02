# =========================
# VPC / Network outputs
# =========================

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "subnet_cidr" {
  description = "CIDR of the public subnet"
  value       = aws_subnet.public.cidr_block
}

# =========================
# Security Group outputs
# =========================

output "security_group_id" {
  description = "ID of the web security group"
  value       = aws_security_group.web_sg.id
}

# =========================
# EC2 Instance outputs
# =========================

output "web_server_instance_ids" {
  description = "IDs of the web server instances"
  value       = [for i in aws_instance.web_server : i.id]
}

output "web_server_public_ips" {
  description = "Public IPs of the web server instances"
  value       = [for i in aws_instance.web_server : i.public_ip]
}

output "web_server_private_ips" {
  description = "Private IPs of the web server instances"
  value       = [for i in aws_instance.web_server : i.private_ip]
}

output "web_server_instance_type" {
  description = "Instance type of the web server"
  value       = aws_instance.web_server[0].instance_type
}

# =========================
# Type examples (by variable)
# =========================

output "environment_info" {
  description = "Example of string type"
  value = {
    name         = var.environment
    type         = "string"
    is_staging   = var.environment == "staging"
    display_name = upper(var.environment)
  }
}

output "storage_info" {
  description = "Example of number type"
  value = {
    disk_size_gb = var.storage_size
    disk_size_mb = var.storage_size * 1024
    type         = "number"
  }
}

output "monitoring_settings" {
  description = "Example of bool type"
  value = {
    enable_monitoring   = var.enable_monitoring
    associate_public_ip = var.associate_public_ip
    type                = "bool"
  }
}

output "allowed_cidr_info" {
  description = "Example of list(string) type"
  value = {
    cidr_blocks = var.allowed_cidr_blocks
    first_cidr  = var.allowed_cidr_blocks[0]
    cidr_count  = length(var.allowed_cidr_blocks)
    type        = "list(string)"
  }
}

output "instance_types_info" {
  description = "Example of list(string) for instance types"
  value = {
    allowed_types = var.allowed_instance_types
    count         = length(var.allowed_instance_types)
    selected      = var.allowed_instance_types[0]
    type          = "list(string)"
  }
}

output "tags_info" {
  description = "Example of map(string) type"
  value = {
    tags       = var.instance_tags
    tag_count  = length(keys(var.instance_tags))
    tag_keys   = keys(var.instance_tags)
    tag_values = values(var.instance_tags)
    type       = "map(string)"
  }
}

output "availability_zones_info" {
  description = "Example of set(string) type"
  value = {
    zones      = var.availability_zones
    zone_count = length(var.availability_zones)
    zones_list = tolist(var.availability_zones)
    type       = "set(string)"
  }
}

output "network_configuration" {
  description = "Example of tuple([string, string, number]) type"
  value = {
    tuple_value   = var.network_config
    vpc_cidr      = var.network_config[0]
    subnet_prefix = var.network_config[1]
    cidr_bits     = var.network_config[2]
    subnet_full   = "${var.network_config[1]}/${var.network_config[2]}"
    type          = "tuple([string, string, number])"
  }
}

output "server_configuration" {
  description = "Example of object type"
  value = {
    config        = var.server_config
    name          = var.server_config.name
    instance_type = var.server_config.instance_type
    monitoring    = var.server_config.monitoring
    storage_gb    = var.server_config.storage_gb
    backup        = var.server_config.backup_enabled
    type          = "object"
  }
}

# =========================
# Common Tags Output
# =========================

output "all_resource_tags" {
  description = "Common tags applied to resources"
  value       = local.common_tags
}
