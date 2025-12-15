output "website_url" {
  description = "The CloudFront URL for the static website"
  value       = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
}

output "cloudfront_domain_name" {
  description = "The CloudFront domain name"
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudfront_distribution_id" {
  description = "The CloudFront distribution ID"
  value       = aws_cloudfront_distribution.s3_distribution.id
}

output "s3_bucket_name" {
  description = "The S3 bucket name hosting the website content"
  value       = aws_s3_bucket.website.bucket
}

output "s3_bucket_arn" {
  description = "The S3 bucket ARN"
  value       = aws_s3_bucket.website.arn
}
