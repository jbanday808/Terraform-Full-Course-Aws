#############################################
# Provider Versions (versions.tf)
# Purpose: Lock provider sources and versions
#          for consistent Terraform behavior.
#############################################

#############################
# 1) Required Providers
#############################

terraform {
  # LABEL: Required provider definitions
  required_providers {
    aws = {
      source  = "hashicorp/aws" # LABEL: AWS provider source
      version = "~> 5.0"        # LABEL: AWS provider version constraint
    }
  }
}
