#############################################
# Remote State Backend (backend.tf)
# Purpose: Store Terraform state remotely
#          in S3 with DynamoDB state locking.
#############################################

#############################
# 1) Terraform Backend
#############################

terraform {
  # LABEL: S3 backend configuration
  backend "s3" {
    bucket         = "tf-state-backend-dev-001" # LABEL: S3 bucket for remote state
    key            = "demo/terraform.tfstate"   # LABEL: State file path/key
    region         = "us-east-1"                # LABEL: AWS region (S3 & DynamoDB)
    dynamodb_table = "terraform-state-locks"    # LABEL: State lock table
    encrypt        = true                       # LABEL: Encrypt state at rest
  }
}
