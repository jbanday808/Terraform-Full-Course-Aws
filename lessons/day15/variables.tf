#############################################
# VARIABLES.TF — Input Variables (Labeled)
# Centralized configuration for regions,
# networking, and compute resources
#############################################

########################
# REGIONS
########################

variable "primary_region" {
  description = "AWS region hosting the primary VPC"
  type        = string
  default     = "us-east-1"
}

variable "secondary_region" {
  description = "AWS region hosting the secondary VPC"
  type        = string
  default     = "us-west-2"
}

########################
# NETWORKING — VPC CIDRs
########################

variable "primary_vpc_cidr" {
  description = "CIDR range for the primary VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "secondary_vpc_cidr" {
  description = "CIDR range for the secondary VPC"
  type        = string
  default     = "10.1.0.0/16"
}

########################
# NETWORKING — SUBNET CIDRs
########################

variable "primary_subnet_cidr" {
  description = "CIDR range for the primary subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "secondary_subnet_cidr" {
  description = "CIDR range for the secondary subnet"
  type        = string
  default     = "10.1.1.0/24"
}

########################
# COMPUTE — EC2 SETTINGS
########################

variable "instance_type" {
  description = "EC2 instance type used in both VPCs"
  type        = string
  default     = "t2.micro"
}

########################
# ACCESS — SSH KEY PAIRS
########################

variable "primary_key_name" {
  description = "SSH key pair name for EC2 in the primary region (us-east-1)"
  type        = string
  default     = "vpc-peering-demo-east"
}

variable "secondary_key_name" {
  description = "SSH key pair name for EC2 in the secondary region (us-west-2)"
  type        = string
  default     = "vpc-peering-demo-west"
}
