#############################################
# PROVIDERS.TF — Terraform & AWS Providers
# Defines Terraform versioning and AWS
# provider configuration
#############################################

########################
# TERRAFORM SETTINGS
########################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

########################
# AWS PROVIDER
########################

provider "aws" {
  region = var.region
}
