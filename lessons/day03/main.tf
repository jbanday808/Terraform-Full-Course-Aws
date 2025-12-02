terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create an S3 bucket
resource "aws_s3_bucket" "tf_test_first_bucket" {
  bucket = "day03-test-bucket"

  tags = {
    Name        = "Day 03 Test Bucket"
    Environment = "Dev"
  }
}
