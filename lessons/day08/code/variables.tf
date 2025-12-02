# variables.tf

# Buckets for the COUNT example
variable "count_bucket_names" {
  type        = list(string)
  description = "Bucket names for the count example"
  default = [
    "day08-count-01-us-east-1"
  ]
}

# Buckets for the FOR_EACH example
variable "each_bucket_names" {
  type        = set(string)
  description = "Bucket names for the for_each example"
  default = [
    "day08-each-01-us-east-1"
  ]
}

# Simple tag values
variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "owner" {
  type        = string
  description = "Owner of the resources"
  default     = "James"
}
