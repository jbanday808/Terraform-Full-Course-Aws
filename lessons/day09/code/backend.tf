# ==============================
# Terraform Backend Configuration
# ==============================

# Note: This is commented out by default
# Uncomment and configure when you're ready to use remote state

/*
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
    bucket         = "tf-state-backend-dev-001"  # S3 bucket for remote state
    key            = "demo/terraform.tfstate"    # Path/key of the state file
    region         = "us-east-1"                 # Region for S3 & DynamoDB
    dynamodb_table = "terraform-state-locks"     # Table for state locking
    encrypt        = true                        # Encrypt state at rest
  }
}
*/

# To use the backend:
# 1. Create an S3 bucket for state storage
# 2. Create a DynamoDB table with primary key "LockID" (String)
# 3. Uncomment the above configuration
# 4. Update bucket, key, region, and table name
# 5. Run: terraform init -reconfigure
