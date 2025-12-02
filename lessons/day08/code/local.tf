# local.tf
# Common tags reused across resources.

locals {
  common_tags = {
    Project     = "terraform-meta-args"
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}
