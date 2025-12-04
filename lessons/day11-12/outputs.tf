# ==============================================================================
# GLOBAL OUTPUTS
# LABEL: Global & Data Sources
# ==============================================================================
output "current_region" {
  description = "AWS region Terraform is using"
  value       = data.aws_region.current.name
}

output "current_account_id" {
  description = "AWS account ID of the caller"
  value       = data.aws_caller_identity.current.account_id
}

output "available_az_names" {
  description = "List of available AZ names in the current region"
  value       = data.aws_availability_zones.available.names
}


# ==============================================================================
# ASSIGNMENT 1
# LABEL: Project Naming Convention
# ==============================================================================
output "formatted_project_name" {
  description = "Project name converted to lowercase and hyphenated"
  value       = local.formatted_project_name
}


# ==============================================================================
# ASSIGNMENT 2
# LABEL: Resource Tagging
# ==============================================================================
output "tagged_vpc_id" {
  description = "ID of the VPC created with merged tags"
  value       = aws_vpc.tagged_vpc.id
}

output "tagged_vpc_tags" {
  description = "All tags applied to the tagged VPC"
  value       = aws_vpc.tagged_vpc.tags
}


# ==============================================================================
# ASSIGNMENT 3
# LABEL: S3 Bucket Naming
# ==============================================================================
output "storage_bucket_name" {
  description = "Final formatted S3 bucket name"
  value       = aws_s3_bucket.storage.bucket
}


# ==============================================================================
# ASSIGNMENT 4
# LABEL: Security Group Port Configuration
# ==============================================================================
output "security_group_id" {
  description = "ID of the dynamic security group"
  value       = aws_security_group.app_sg.id
}

output "security_group_vpc_id" {
  description = "VPC ID where the security group is created"
  value       = aws_security_group.app_sg.vpc_id
}

output "formatted_ports_documentation" {
  description = "Ports formatted as a single documentation string"
  value       = local.formatted_ports
}


# ==============================================================================
# ASSIGNMENT 5
# LABEL: Environment Configuration Lookup
# ==============================================================================
output "app_server_id" {
  description = "EC2 instance ID for the environment-based app server"
  value       = aws_instance.app_server.id
}

output "app_server_instance_type" {
  description = "Instance type selected via lookup for the app server"
  value       = aws_instance.app_server.instance_type
}


# ==============================================================================
# ASSIGNMENT 6
# LABEL: Instance Type Validation
# ==============================================================================
output "validated_instance_id" {
  description = "EC2 instance ID created using the validated instance type"
  value       = aws_instance.validated_instance.id
}

output "validated_instance_type" {
  description = "The instance type that passed validation"
  value       = aws_instance.validated_instance.instance_type
}


# ==============================================================================
# ASSIGNMENT 7
# LABEL: Backup Configuration
# ==============================================================================
output "backup_configuration" {
  description = "Backup configuration summary (without credential)"
  value = {
    name    = local.backup_config.name
    enabled = local.backup_config.enabled
  }
}


# ==============================================================================
# ASSIGNMENT 8
# LABEL: File Path Processing
# ==============================================================================
output "config_file_status" {
  description = "Map of config file paths to their existence (true/false)"
  value       = local.file_status
}

output "config_directories" {
  description = "Map of config file paths to their parent directories"
  value       = local.config_dirs
}


# ==============================================================================
# ASSIGNMENT 9
# LABEL: Resource Location Management
# ==============================================================================
output "all_locations" {
  description = "Combined list of user and default locations (with duplicates)"
  value       = local.all_locations
}

output "unique_locations" {
  description = "Set of unique AWS locations after merging"
  value       = local.unique_locations
}


# ==============================================================================
# ASSIGNMENT 10
# LABEL: Cost Calculation
# ==============================================================================
output "positive_costs" {
  description = "Monthly costs converted to positive values"
  value       = local.positive_costs
}

output "maximum_monthly_cost" {
  description = "Highest monthly cost after conversion"
  value       = local.max_cost
}

output "total_monthly_cost" {
  description = "Sum of all monthly costs (absolute values)"
  value       = local.total_cost
}

output "average_monthly_cost" {
  description = "Average monthly cost across all entries"
  value       = local.avg_cost
}


# ==============================================================================
# ASSIGNMENT 11
# LABEL: Timestamp Management
# ==============================================================================
output "timestamped_bucket_name" {
  description = "Name of the timestamped backup bucket"
  value       = aws_s3_bucket.timestamped_bucket.bucket
}

output "timestamped_backup_name" {
  description = "Generated backup name including date suffix"
  value       = local.timestamped_name
}

output "resource_date_suffix" {
  description = "YYYYMMDD date suffix used in resource naming"
  value       = local.resource_date_suffix
}

output "tag_date_format" {
  description = "DD-MM-YYYY formatted date used in tags"
  value       = local.tag_date_format
}


# ==============================================================================
# ASSIGNMENT 12
# LABEL: File Content Handling
# ==============================================================================
output "config_file_exists" {
  description = "Indicates whether config.json was found"
  value       = local.config_file_exists
}

output "config_database_settings" {
  description = "Database configuration loaded from config.json or default"
  value       = local.config_data.database
}

output "app_config_secret_arn" {
  description = "ARN of the AWS Secrets Manager secret that stores app config"
  value       = aws_secretsmanager_secret.app_config.arn
}
