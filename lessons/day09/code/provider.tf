# ==============================
# AWS Provider Settings
# ==============================

provider "aws" {
  region = var.aws_region

  # Default tags applied automatically to all AWS resources
  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Project   = "Day09-Lifecycle-Demo"
    }
  }
}

