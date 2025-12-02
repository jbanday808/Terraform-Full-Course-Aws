# =============================================================================
# Day 08: Meta-Arguments in Terraform (count and for_each)
# =============================================================================
# This file demonstrates the use of meta-arguments:
# 1. count - Creates multiple instances using index-based iteration
# 2. for_each - Creates multiple instances using map/set iteration
# =============================================================================

# main.tf

#########################################
# 1. COUNT – create buckets by index
#########################################

resource "aws_s3_bucket" "count_buckets" {
  count  = length(var.count_bucket_names)
  bucket = var.count_bucket_names[count.index]

  tags = merge(
    local.common_tags,
    {
      Example = "count"
      Index   = tostring(count.index)
    }
  )
}

#########################################
# 2. FOR_EACH – create buckets by name
#########################################

resource "aws_s3_bucket" "each_buckets" {
  for_each = var.each_bucket_names
  bucket   = each.value

  tags = merge(
    local.common_tags,
    {
      Example = "for_each"
      Key     = each.key
    }
  )
}

#########################################
# 3. DEPENDS_ON – explicit dependency
#########################################

resource "aws_s3_bucket" "primary_bucket" {
  bucket = "terraform-primary-01-us-east-1"

  tags = merge(
    local.common_tags,
    {
      Role = "primary"
    }
  )
}

resource "aws_s3_bucket" "logging_bucket" {
  bucket = "terraform-logging-01-us-east-1"

  # Ensure primary bucket exists first
  depends_on = [aws_s3_bucket.primary_bucket]

  tags = merge(
    local.common_tags,
    {
      Role = "logging"
    }
  )
}

#########################################
# 4. LIFECYCLE – safe, but destroy allowed
#########################################

resource "aws_s3_bucket" "protected_bucket" {
  bucket = "terraform-protected-01-us-east-1"

  lifecycle {
    create_before_destroy = true   # Replace safely
    ignore_changes        = [tags] # Ignore tag-only updates
  }

  tags = merge(
    local.common_tags,
    {
      Critical = "true"
    }
  )
}

#########################################
# 5. PROVIDER – create bucket in us-west-2
#########################################

resource "aws_s3_bucket" "west_bucket" {
  provider = aws.west
  bucket   = "terraform-west-01-us-west-2"

  tags = merge(
    local.common_tags,
    {
      Region = "us-west-2"
      Note   = "Created with provider alias"
    }
  )
}



