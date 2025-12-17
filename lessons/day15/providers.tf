#############################################
# PROVIDERS.TF — Multi-Region AWS Providers
# Sets up two AWS providers (Primary + Secondary)
# for cross-region VPC peering deployments
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
# AWS PROVIDERS (ALIASES)
########################

# Primary Region Provider (us-east-1)
provider "aws" {
  alias  = "primary"
  region = var.primary_region

  default_tags {
    tags = {
      Environment = "Demo"
      Project     = "VPC-Peering-Demo"
      RegionRole  = "Primary"
    }
  }
}

# Secondary Region Provider (us-west-2)
provider "aws" {
  alias  = "secondary"
  region = var.secondary_region

  default_tags {
    tags = {
      Environment = "Demo"
      Project     = "VPC-Peering-Demo"
      RegionRole  = "Secondary"
    }
  }
}
