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
# LABEL: String Function
# ==============================================================================

output "formatted_project_name" {
  description = "Project name converted to lowercase and hyphenated (lower/replace)"
  value       = local.formatted_project_name
}


# ==============================================================================
# ASSIGNMENT 2
# LABEL: Resource Tagging
# LABEL: Collection Function
# ==============================================================================

output "tagged_vpc_id" {
  description = "ID of the VPC created with merged tags (merge)"
  value       = aws_vpc.tagged_vpc.id
}

output "tagged_vpc_tags" {
  description = "All tags applied to the tagged VPC"
  value       = aws_vpc.tagged_vpc.tags
}

output "tagged_vpc_default_nacl_name" {
  description = "Name tag of the default NACL for tagged_vpc"
  value       = aws_default_network_acl.tagged_vpc_default_nacl.tags["Name"]
}

output "tagged_vpc_default_route_table_name" {
  description = "Name tag of the default route table for tagged_vpc"
  value       = aws_default_route_table.tagged_vpc_default_rt.tags["Name"]
}


# ==============================================================================
# ASSIGNMENT 3
# LABEL: S3 Bucket Naming
# LABEL: String Function
# ==============================================================================

output "storage_bucket_name" {
  description = "Final formatted S3 bucket name created for storage (substr/lower/replace)"
  value       = aws_s3_bucket.storage.bucket
}


# ==============================================================================
# ASSIGNMENT 4
# LABEL: Security Group Port Configuration
# LABEL: String Function
# LABEL: Collection Function
# LABEL: Type Conversion
# ==============================================================================

output "sg_demo_vpc_id" {
  description = "ID of the VPC used for the security group demo"
  value       = aws_vpc.sg_vpc.id
}

output "security_group_id" {
  description = "ID of the dynamic security group with port rules"
  value       = aws_security_group.app_sg.id
}

output "security_group_vpc_id" {
  description = "VPC ID where the security group is created"
  value       = aws_security_group.app_sg.vpc_id
}

output "formatted_ports_documentation" {
  description = "Ports formatted as a single documentation string (split/join/for/tonumber)"
  value       = local.formatted_ports
}

output "sg_vpc_default_nacl_name" {
  description = "Name tag of the default NACL for sg_vpc"
  value       = aws_default_network_acl.sg_vpc_default_nacl.tags["Name"]
}

output "sg_vpc_default_route_table_name" {
  description = "Name tag of the default route table for sg_vpc"
  value       = aws_default_route_table.sg_vpc_default_rt.tags["Name"]
}


# ==============================================================================
# SHARED EC2 NETWORKING
# LABEL: EC2 Demo VPC, Subnet, SG, NACL, Route Table
# LABEL: Lookup Function (Assignments 5 & 6 use lookup/validation on this network)
# ==============================================================================

output "ec2_demo_vpc_id" {
  description = "ID of the VPC used for EC2 demo instances"
  value       = aws_vpc.ec2_demo_vpc.id
}

output "ec2_demo_subnet_id" {
  description = "ID of the subnet used for EC2 demo instances"
  value       = aws_subnet.ec2_demo_subnet.id
}

output "ec2_demo_sg_id" {
  description = "ID of the security group used for EC2 demo instances"
  value       = aws_security_group.ec2_demo_sg.id
}

output "ec2_demo_default_nacl_name" {
  description = "Name tag of the default NACL for ec2_demo_vpc"
  value       = aws_default_network_acl.ec2_demo_default_nacl.tags["Name"]
}

output "ec2_demo_default_route_table_name" {
  description = "Name tag of the default route table for ec2_demo_vpc"
  value       = aws_default_route_table.ec2_demo_default_rt.tags["Name"]
}


# ==============================================================================
# ASSIGNMENT 5
# LABEL: Environment Configuration Lookup
# LABEL: Lookup Function
# ==============================================================================

output "app_server_id" {
  description = "EC2 instance ID for the environment-based app server (lookup)"
  value       = aws_instance.app_server.id
}

output "app_server_instance_type" {
  description = "Instance type selected via lookup for the app server"
  value       = aws_instance.app_server.instance_type
}


# ==============================================================================
# ASSIGNMENT 6
# LABEL: Instance Type Validation
# LABEL: Validation Function
# ==============================================================================

output "validated_instance_id" {
  description = "EC2 instance ID created using the validated instance type (regex/can/length)"
  value       = aws_instance.validated_instance.id
}

output "validated_instance_type" {
  description = "The instance type that passed validation rules"
  value       = aws_instance.validated_instance.instance_type
}


# ==============================================================================
# ASSIGNMENT 7
# LABEL: Backup Configuration
# LABEL: Validation Function
# LABEL: endswith(), sensitive()
# ==============================================================================

# Non-sensitive summary output
output "backup_configuration" {
  description = "Backup configuration (name validated with endswith, credential hidden)"
  value = {
    name    = local.backup_config.name
    enabled = local.backup_config.enabled
  }
}

# Sensitive full configuration object
output "backup_configuration_sensitive" {
  description = "Full backup configuration including sensitive credential"
  value       = sensitive(local.backup_config)
  sensitive   = true
}


# ==============================================================================
# ASSIGNMENT 8
# LABEL: File Path Processing
# LABEL: File Function
# ==============================================================================

output "config_file_status" {
  description = "Map of config file paths to their existence (true/false) using fileexists()"
  value       = local.file_status
}

output "config_directories" {
  description = "Map of config file paths to their parent directories using dirname()"
  value       = local.config_dirs
}


# ==============================================================================
# ASSIGNMENT 9
# LABEL: Resource Location Management
# LABEL: Collection Function
# ==============================================================================

output "all_locations" {
  description = "Combined list of user and default locations (with duplicates) using concat()"
  value       = local.all_locations
}

output "unique_locations" {
  description = "Set of unique AWS locations after merging using toset()"
  value       = local.unique_locations
}


# ==============================================================================
# ASSIGNMENT 10
# LABEL: Cost Calculation
# LABEL: Numeric Function
# LABEL: Collection Function
# ==============================================================================

output "positive_costs" {
  description = "Monthly costs converted to absolute values using abs()"
  value       = local.positive_costs
}

output "maximum_monthly_cost" {
  description = "Highest monthly cost after conversion using max()"
  value       = local.max_cost
}

output "total_monthly_cost" {
  description = "Sum of all monthly costs (absolute values) using sum()"
  value       = local.total_cost
}

output "average_monthly_cost" {
  description = "Average monthly cost (sum()/length())"
  value       = local.avg_cost
}


# ==============================================================================
# ASSIGNMENT 11
# LABEL: Timestamp Management
# LABEL: Date/Time Function
# ==============================================================================

output "timestamped_bucket_name" {
  description = "Name of the timestamped backup bucket (daily-backup-YYYYMMDD)"
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
# LABEL: File Function
# LABEL: Type Conversion
# ==============================================================================

output "config_file_exists" {
  description = "Indicates whether config.json was found using fileexists()"
  value       = local.config_file_exists
}

output "config_database_settings" {
  description = "Database configuration loaded from config.json or default (file/jsondecode)"
  value       = local.config_data.database
}

output "app_config_secret_arn" {
  description = "ARN of the AWS Secrets Manager secret storing app config (jsonencode used in secret version)"
  value       = aws_secretsmanager_secret.app_config.arn
}
