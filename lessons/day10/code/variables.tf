variable "aws_region" {
  description = "AWS region (default: us-east-1)."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name: dev or prod."
  type        = string
  default     = "dev"
}

variable "instance_count" {
  description = "Number of EC2 instances to create for the splat example."
  type        = number
  default     = 2
}

variable "vpc_id" {
  description = "Optional existing VPC ID. Leave null to use demo-created VPC."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Optional existing subnet ID. Leave null to use demo-created subnet."
  type        = string
  default     = null
}

variable "ingress_rules" {
  description = "List of ingress rules for dynamic security group."
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
