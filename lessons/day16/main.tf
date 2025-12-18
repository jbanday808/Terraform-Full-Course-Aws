#############################################
# IAM Users from CSV (main.tf)
# Purpose: Read users.csv, create IAM users,
#          and enable console login (reset on first login).
#############################################

#############################
# 1) Account Context
#############################

# Label: Identify the current AWS account (useful for audits and outputs)
data "aws_caller_identity" "current" {}

# Label: Output the AWS Account ID
output "account_id" {
  description = "AWS Account ID where these IAM resources are created."
  value       = data.aws_caller_identity.current.account_id
}

#############################
# 2) Input Data (CSV)
#############################

# Label: Load users from users.csv (first_name,last_name,department,job_title)
locals {
  users = csvdecode(file("${path.module}/users.csv"))
}

# Label: Output full names for quick verification
output "user_names" {
  description = "List of user full names loaded from users.csv."
  value       = [for user in local.users : "${user.first_name} ${user.last_name}"]
}

#############################
# 3) IAM Users
#############################

# Label: Create one IAM user per CSV row (keyed by first_name)
resource "aws_iam_user" "users" {
  for_each = { for user in local.users : user.first_name => user }

  # Label: Username format = first initial + last name (all lowercase)
  name = lower("${substr(each.value.first_name, 0, 1)}${each.value.last_name}")

  # Label: Standardized path for IAM users
  path = "/users/"

  # Label: Helpful tags for tracking and reporting
  tags = {
    DisplayName = "${each.value.first_name} ${each.value.last_name}"
    Department  = each.value.department
    JobTitle    = each.value.job_title
  }
}

#############################
# 4) Console Access (Login Profile)
#############################

# Label: Create console login profile (forces password reset on first login)
resource "aws_iam_user_login_profile" "users" {
  for_each = aws_iam_user.users

  user                    = each.value.name
  password_reset_required = true

  # Label: Avoid Terraform drift for password-related settings
  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
    ]
  }
}

#############################
# 5) Outputs (Safe + Sensitive)
#############################

# Label: Sensitive placeholder output (does not expose real passwords)
output "user_passwords" {
  description = "Sensitive placeholder message confirming console password was created (actual password not shown)."
  value = {
    for user, profile in aws_iam_user_login_profile.users :
    user => "Password created - user must reset on first login"
  }
  sensitive = true
}
