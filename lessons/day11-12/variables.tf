# ==============================================================================
# GLOBAL SETTINGS
# LABEL: AWS Region
# ==============================================================================
variable "aws_region" {
  type        = string
  description = "AWS region used for all deployments"
  default     = "us-east-1"
}

# ==============================================================================
# ASSIGNMENT 1
# LABEL: Project Naming Convention
# ==============================================================================
variable "project_name" {
  type        = string
  description = "Name of the project used as the base identifier"
  default     = "Project ALPHA Resource"
}

# ==============================================================================
# ASSIGNMENT 2
# LABEL: Resource Tagging
# ==============================================================================
variable "default_tags" {
  type        = map(string)
  description = "Default resource tags"

  # LABEL: Local - fallback values
  default = {
    company    = "TechCorp"
    managed_by = "terraform"
  }
}

variable "environment_tags" {
  type        = map(string)
  description = "Environment-specific resource tags"

  # LABEL: Local - environment-specific values
  default = {
    environment = "production"
    cost_center = "cc-123"
  }
}

# ==============================================================================
# ASSIGNMENT 3
# LABEL: S3 Bucket Naming
# ==============================================================================
variable "bucket_name" {
  type        = string
  description = "Raw input name for S3 bucket (will be cleaned and formatted)"
  default     = "ProjectAlphaStorageBucket with CAPS and spaces!!!"
}

# ==============================================================================
# ASSIGNMENT 4
# LABEL: Security Group Port Configuration
# ==============================================================================
variable "allowed_ports" {
  type        = string
  description = "Comma-separated list of allowed ports"
  default     = "80,443,8080,3306"
}

# ==============================================================================
# ASSIGNMENT 5
# LABEL: Environment Configuration Lookup
# ==============================================================================
variable "environment" {
  type        = string
  description = "Deployment environment for EC2, S3, and tagging operations"
  default     = "dev"

  # LABEL: Validation - allowed environments
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod"
  }
}

variable "instance_sizes" {
  type        = map(string)
  description = "Instance size lookup map based on environment"

  # LABEL: Local - environment → instance size
  default = {
    dev     = "t2.micro"
    staging = "t3.small"
    prod    = "t3.large"
  }
}

# ==============================================================================
# ASSIGNMENT 6
# LABEL: Instance Type Validation
# ==============================================================================
variable "instance_type" {
  type        = string
  description = "EC2 instance type used for validation tests"
  default     = "t2.micro"

  # LABEL: Validation - length check
  validation {
    condition     = length(var.instance_type) >= 2 && length(var.instance_type) <= 20
    error_message = "Instance type must be between 2 and 20 characters"
  }

  # LABEL: Validation - must start with t2 or t3
  validation {
    condition     = can(regex("^t[2-3]\\.", var.instance_type))
    error_message = "Instance type must start with t2 or t3"
  }
}

# ==============================================================================
# ASSIGNMENT 7
# LABEL: Backup Configuration
# ==============================================================================
variable "backup_name" {
  type        = string
  description = "Backup configuration name used in resource naming"
  default     = "daily_backup"

  # LABEL: Validation - required suffix
  validation {
    condition     = endswith(var.backup_name, "_backup")
    error_message = "backup_name must end with '_backup'"
  }
}

variable "credential" {
  type        = string
  description = "Credential for backup configuration (sensitive)"
  default     = "xyz123"
  sensitive   = true   # LABEL: Sensitive value
}

# ==============================================================================
# ASSIGNMENT 9
# LABEL: Resource Location Management
# ==============================================================================
variable "user_locations" {
  type        = list(string)
  description = "User-provided AWS regions (may include duplicates)"
  default     = ["us-east-1", "us-west-2", "us-east-1"]
}

variable "default_locations" {
  type        = list(string)
  description = "Default AWS regions used in location merging"
  default     = ["us-west-1"]
}

# ==============================================================================
# ASSIGNMENT 10
# LABEL: Cost Calculation
# ==============================================================================
variable "monthly_costs" {
  type        = list(number)
  description = "List of monthly infrastructure costs; negatives represent credits"
  default     = [-50, 100, 75, 200]
}
