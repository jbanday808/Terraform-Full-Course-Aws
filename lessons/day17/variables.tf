#############################################
# AWS Region Configuration
#############################################

variable "aws_region" {
  description = "AWS region where all resources will be deployed"
  type        = string
  default     = "us-east-1"
}

#############################################
# Application Configuration
#############################################

variable "app_name" {
  description = "Name of the Elastic Beanstalk application"
  type        = string
  default     = "my-app-bluegreen"
}

#############################################
# Elastic Beanstalk Platform Configuration
#############################################

variable "solution_stack_name" {
  description = "Elastic Beanstalk solution stack (platform and runtime)"
  type        = string

  # Node.js 20 running on 64-bit Amazon Linux 2023
  default = "64bit Amazon Linux 2023 v6.6.8 running Node.js 20"
}

#############################################
# EC2 Instance Configuration
#############################################

variable "instance_type" {
  description = "EC2 instance type used by Elastic Beanstalk environments"
  type        = string
  default     = "t3.micro"
}

#############################################
# Resource Tagging Configuration
#############################################

variable "tags" {
  description = "Common tags applied to all Terraform-managed resources"
  type        = map(string)

  default = {
    Project     = "BlueGreenDeployment"
    Environment = "Demo"
    ManagedBy   = "Terraform"
  }
}
