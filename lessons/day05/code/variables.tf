# Input Variables - Values provided to Terraform configuration

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"   # Default value (overridden by terraform.tfvars)
}

variable "bucket_name" {
  description = "Base S3 bucket name"
  type        = string
  default     = "day05-terraform-demo"   # Unique name to avoid AWS conflicts
}
