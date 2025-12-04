# ==============================================================================
# PROVIDER CONFIGURATION
# LABEL: Overview
# ==============================================================================
# Defines Terraform and AWS provider requirements.
# Ensures consistent provider versions and sets the default AWS region.
# ==============================================================================

terraform {
  # LABEL: Structure - required provider definitions
  required_providers {
    aws = {
      source  = "hashicorp/aws"   # LABEL: Provider Source
      version = "~> 5.0"          # LABEL: Provider Version Constraint
    }
  }

  required_version = ">= 1.0"      # LABEL: Terraform Core Version
}

# ==============================================================================
# AWS PROVIDER
# LABEL: Provider Configuration
# ==============================================================================
# Sets the AWS region used for all deployments.
# ==============================================================================

provider "aws" {
  region = "us-east-1"             # LABEL: Default Region
}
