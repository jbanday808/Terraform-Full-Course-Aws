#############################################
# Elastic Beanstalk Application Outputs
#############################################

output "application_name" {
  description = "Name of the Elastic Beanstalk application"
  value       = aws_elastic_beanstalk_application.app.name
}

#############################################
# IAM Outputs (Beanstalk Roles/Profiles)
#############################################

output "eb_ec2_role_name" {
  description = "IAM role name used by Elastic Beanstalk EC2 instances"
  value       = aws_iam_role.eb_ec2_role.name
}

output "eb_ec2_instance_profile_name" {
  description = "Instance profile attached to Elastic Beanstalk EC2 instances"
  value       = aws_iam_instance_profile.eb_ec2_profile.name
}

output "eb_service_role_name" {
  description = "Service role used by Elastic Beanstalk to manage environments"
  value       = aws_iam_role.eb_service_role.name
}

#############################################
# Application Version Outputs
#############################################

output "blue_version_label" {
  description = "Elastic Beanstalk application version label deployed to Blue"
  value       = aws_elastic_beanstalk_application_version.v1.name
}

output "green_version_label" {
  description = "Elastic Beanstalk application version label deployed to Green"
  value       = aws_elastic_beanstalk_application_version.v2.name
}

#############################################
# Blue Environment Outputs (Production)
#############################################

output "blue_environment_name" {
  description = "Name of the Blue (Production) environment"
  value       = aws_elastic_beanstalk_environment.blue.name
}

output "blue_environment_cname" {
  description = "CNAME of the Blue (Production) environment"
  value       = aws_elastic_beanstalk_environment.blue.cname
}

output "blue_environment_url" {
  description = "Public URL of the Blue (Production) environment"
  value       = "http://${aws_elastic_beanstalk_environment.blue.cname}"
}

#############################################
# Green Environment Outputs (Staging)
#############################################

output "green_environment_name" {
  description = "Name of the Green (Staging) environment"
  value       = aws_elastic_beanstalk_environment.green.name
}

output "green_environment_cname" {
  description = "CNAME of the Green (Staging) environment"
  value       = aws_elastic_beanstalk_environment.green.cname
}

output "green_environment_url" {
  description = "Public URL of the Green (Staging) environment"
  value       = "http://${aws_elastic_beanstalk_environment.green.cname}"
}

#############################################
# S3 Application Artifact Storage Outputs
#############################################

output "app_versions_bucket_name" {
  description = "S3 bucket name used to store application versions"
  value       = aws_s3_bucket.app_versions.bucket
}

output "app_v1_s3_key" {
  description = "S3 object key for application version 1 (Blue)"
  value       = aws_s3_object.app_v1.key
}

output "app_v2_s3_key" {
  description = "S3 object key for application version 2 (Green)"
  value       = aws_s3_object.app_v2.key
}

#############################################
# Blue-Green Traffic Swap Command
#############################################

output "swap_command" {
  description = "AWS CLI command to swap Elastic Beanstalk environment CNAMEs"
  value       = <<-EOT
    aws elasticbeanstalk swap-environment-cnames \
      --source-environment-name ${aws_elastic_beanstalk_environment.blue.name} \
      --destination-environment-name ${aws_elastic_beanstalk_environment.green.name} \
      --region ${var.aws_region}
  EOT
}

#############################################
# Blue-Green Deployment Instructions
#############################################

output "instructions" {
  description = "Step-by-step instructions for executing and validating the blue-green deployment"
  value       = <<-EOT

    ========================================
    Blue-Green Deployment Demo Instructions
    ========================================

    1. VERIFY BLUE ENVIRONMENT (Production - v1.0)
       Visit:
       http://${aws_elastic_beanstalk_environment.blue.cname}

       Expected Response:
       "Welcome to Version 1.0 - Blue Environment"

    2. VERIFY GREEN ENVIRONMENT (Staging - v2.0)
       Visit:
       http://${aws_elastic_beanstalk_environment.green.cname}

       Expected Response:
       "Welcome to Version 2.0 - Green Environment"

    3. PERFORM THE TRAFFIC SWAP
       Run the following AWS CLI command:

       aws elasticbeanstalk swap-environment-cnames \
         --source-environment-name ${aws_elastic_beanstalk_environment.blue.name} \
         --destination-environment-name ${aws_elastic_beanstalk_environment.green.name} \
         --region ${var.aws_region}

    4. VERIFY THE SWAP (1–2 minutes)
       Production URL now serves v2.0:
       http://${aws_elastic_beanstalk_environment.blue.cname}

       Staging URL now serves v1.0:
       http://${aws_elastic_beanstalk_environment.green.cname}

    5. ROLLBACK (IF REQUIRED)
       Re-run the same swap command to immediately revert traffic.

    ========================================

  EOT
}
