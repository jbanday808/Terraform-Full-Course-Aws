# ==============================================================================
# TERRAFORM SETTINGS & PROVIDER REQUIREMENTS
# LABEL: Overview
# ==============================================================================
# Defines the Terraform version, required providers, and AWS provider source.
# Ensures consistent versioning for all deployments.
# ==============================================================================

terraform {
  required_version = ">= 1.0"   # LABEL: Terraform Core Version Requirement

  required_providers {
    aws = {
      source  = "hashicorp/aws" # LABEL: Provider Source Registry
      version = "~> 5.0"        # LABEL: Provider Version Constraint
    }
  }
}

# ==============================================================================
# AWS PROVIDER CONFIGURATION
# LABEL: Provider Configuration
# ==============================================================================
# Region and environment values come from variables.tf (aws_region, environment).
# Default tags are automatically applied to all created AWS resources.
# ==============================================================================

provider "aws" {
  region = var.aws_region        # LABEL: Default AWS Region

  # ==============================================================================
  # DEFAULT TAGS (APPLIED TO ALL RESOURCES)
  # LABEL: Default Tags
  # ==============================================================================
  default_tags {
    tags = {
      Project     = "Day11-12-Terraform-Functions-Demo" # LABEL: Tag - Project Name
      Environment = var.environment                     # LABEL: Tag - Deployment Environment
      ManagedBy   = "Terraform"                         # LABEL: Tag - Management Tool
    }
  }
}
