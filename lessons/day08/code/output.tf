# output.tf

#########################################
# Outputs using for-expressions (for loops)
#########################################

# COUNT: list all bucket names
output "count_bucket_names" {
  description = "Bucket names created with count"
  value       = [for b in aws_s3_bucket.count_buckets : b.bucket]
}

# COUNT: list all bucket IDs
output "count_bucket_ids" {
  description = "Bucket IDs created with count"
  value       = [for b in aws_s3_bucket.count_buckets : b.id]
}

# FOR_EACH: list all bucket names
output "each_bucket_names" {
  description = "Bucket names created with for_each"
  value       = [for b in aws_s3_bucket.each_buckets : b.bucket]
}

# FOR_EACH: map name -> ID
output "each_bucket_name_to_id" {
  description = "Map of each bucket name to ID (for_each)"
  value       = { for name, b in aws_s3_bucket.each_buckets : name => b.id }
}
