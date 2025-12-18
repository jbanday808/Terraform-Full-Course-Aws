#############################################
# Provider Configuration (provider.tf)
# Purpose: Define Terraform and AWS provider
#          requirements and default region.
#############################################

#############################
# 1) Terraform Settings
#############################

terraform {
  # LABEL: Required provider definitions
  required_providers {
    aws = {
      source  = "hashicorp/aws" # LABEL: AWS provider source
      version = "~> 5.0"        # LABEL: AWS provider version constraint
    }
  }

  # LABEL: Minimum supported Terraform version
  required_version = ">= 1.0"
}

#############################
# 2) AWS Provider
#############################

# LABEL: Global AWS provider configuration
# Sets the default region for all AWS resources
provider "aws" {
  region = "us-east-1" # LABEL: Default AWS region
}
