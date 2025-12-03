terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # Standard tags applied to all AWS resources
  default_tags {
    tags = {
      Project     = "Day10-Terraform-Expressions-Demo"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
