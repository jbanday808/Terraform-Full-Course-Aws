############################################
# REGION & ENVIRONMENT SETTINGS
############################################

variable "aws_region" {
  description = "AWS region where all resources will be deployed."
  type        = string
  default     = "us-east-1"

  validation {
    condition     = contains(["us-east-1", "us-west-2", "eu-west-1"], var.aws_region)
    error_message = "aws_region must be one of: us-east-1, us-west-2, eu-west-1."
  }
}

variable "environment" {
  description = "Deployment environment name (dev or prod)."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be either dev or prod."
  }
}

############################################
# RESOURCE SETTINGS
############################################

variable "instance_count" {
  description = "Number of EC2 instances to create for the splat expression demo."
  type        = number
  default     = 2

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 10
    error_message = "instance_count must be between 1 and 10."
  }
}

############################################
# NETWORK SETTINGS (OPTIONAL OVERRIDES)
############################################

variable "vpc_id" {
  description = "Existing VPC ID to use. Leave null to use the Day 10 demo VPC created in vpc.tf."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Existing subnet ID to use. Leave null to use the demo public subnet created in vpc.tf."
  type        = string
  default     = null
}

############################################
# SECURITY GROUP RULES (DYNAMIC BLOCK INPUT)
############################################

variable "ingress_rules" {
  description = "Ingress rules used to dynamically build security group entries."
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))

  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS"
    }
  ]
}
