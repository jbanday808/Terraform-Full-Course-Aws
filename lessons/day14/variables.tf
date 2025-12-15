variable "region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket name used to host the static website"
  type        = string
  default     = "day14-static-website"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Project identifier used for tagging and naming"
  type        = string
  default     = "day14-static-website"
}

variable "tags" {
  description = "Common tags applied to all AWS resources"
  type        = map(string)
  default = {
    Project     = "day14-static-website"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}
