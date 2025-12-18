#############################################
# IAM Groups and Memberships (groups.tf)
# Purpose: Create IAM groups and automatically
#          assign users based on tags from users.csv
#############################################

#############################
# 1) IAM Groups
#############################

# Label: Education IAM group
resource "aws_iam_group" "education" {
  name = "Education"
  path = "/groups/"
}

# Label: Managers IAM group
resource "aws_iam_group" "managers" {
  name = "Managers"
  path = "/groups/"
}

# Label: Engineers IAM group
resource "aws_iam_group" "engineers" {
  name = "Engineers"
  path = "/groups/"
}

#############################
# 2) Group Memberships
#############################

# Label: Automatically add users to Education group
# Criteria: Department tag equals "Education"
resource "aws_iam_group_membership" "education_members" {
  name  = "education-group-membership"
  group = aws_iam_group.education.name

  users = [
    for user in aws_iam_user.users :
    user.name
    if user.tags.Department == "Education"
  ]
}

# Label: Automatically add users to Managers group
# Criteria: JobTitle contains "Manager" or "CEO"
resource "aws_iam_group_membership" "managers_members" {
  name  = "managers-group-membership"
  group = aws_iam_group.managers.name

  users = [
    for user in aws_iam_user.users :
    user.name
    if contains(keys(user.tags), "JobTitle")
    && can(regex("Manager|CEO", user.tags.JobTitle))
  ]
}

# Label: Automatically add users to Engineers group
# Criteria: Department tag equals "Engineering"
# Note: No users currently match this condition in users.csv
resource "aws_iam_group_membership" "engineers_members" {
  name  = "engineers-group-membership"
  group = aws_iam_group.engineers.name

  users = [
    for user in aws_iam_user.users :
    user.name
    if user.tags.Department == "Engineering"
  ]
}
