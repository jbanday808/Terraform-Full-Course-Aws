#############################################
# AWS Provider Configuration (provider.tf)
# Purpose: Define the default AWS provider
#          and region for all resources.
#############################################

#############################
# 1) AWS Provider
#############################

# LABEL: Global AWS provider configuration
# Sets the default region for all AWS resources
provider "aws" {
  region = "us-east-1" # LABEL: Default AWS region
}
