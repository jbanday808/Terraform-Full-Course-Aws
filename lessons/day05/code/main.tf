# Reference with var. prefix in main.tf
resource "aws_s3_bucket" "demo" {
  bucket = var.bucket_name # Using input variable

  tags = {
    Environment = var.environment # Using input variable
  }
}
