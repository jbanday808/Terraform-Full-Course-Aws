# ==============================
# Local Values
# ==============================

locals {
  # Common tags applied to all resources
  common_tags = {
    Environment = var.environment
    Team        = "DevOps"
    ManagedBy   = "Terraform"
    Project     = "Lifecycle-Demo"
  }

  # Timestamp for unique naming
  timestamp = formatdate("YYYY-MM-DD", timestamp())

  # Environment-specific settings
  env_config = {
    dev = {
      instance_type = "t2.micro"
      multi_az      = false
    }
    staging = {
      instance_type = "t2.small"
      multi_az      = false
    }
    prod = {
      instance_type = "t2.medium"
      multi_az      = true
    }
  }

  # Configuration selected by environment (dev/staging/prod)
  current_env_config = lookup(local.env_config, var.environment, local.env_config["dev"])

  # Updated bucket naming prefix to match new lifecycle demo naming
  bucket_prefix = "day09-demo-lifecycle-001"

  # Region formatting for names (e.g., us-east-1 → useast1)
  region_short = replace(data.aws_region.current.name, "-", "")

  # Number of availability zones in current region
  az_count = length(data.aws_availability_zones.available.names)
}
