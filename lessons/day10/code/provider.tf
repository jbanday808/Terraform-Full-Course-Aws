############################################
# TERRAFORM SETTINGS & PROVIDER REQUIREMENTS
############################################
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

############################################
# AWS PROVIDER CONFIGURATION
############################################
provider "aws" {
  # Region comes from dev.tfvars or prod.tfvars
  region = var.aws_region

  ############################################
  # DEFAULT TAGS (APPLIED TO ALL RESOURCES)
  ############################################
  default_tags {
    tags = {
      Project     = "Day10-Terraform-Expressions-Demo"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
