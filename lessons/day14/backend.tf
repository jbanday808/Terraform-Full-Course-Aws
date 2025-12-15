# backend.tf
# Store Terraform state remotely in S3 with DynamoDB state locking.

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "tf-state-backend-dev-001" # S3 bucket for remote state
    key            = "demo/terraform.tfstate"   # Path/key of the state file
    region         = "us-east-1"                # Region for S3 & DynamoDB
    dynamodb_table = "terraform-state-locks"    # Table for state locking
    encrypt        = true                       # Encrypt state at rest
  }
}
