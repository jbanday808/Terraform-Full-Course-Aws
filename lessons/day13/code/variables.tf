variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "shared_vpc_name" {
  description = "Name tag for the shared network VPC"
  type        = string
  default     = "shared-network-vpc"
}

variable "subnet_1_name" {
  description = "Name tag for subnet-1"
  type        = string
  default     = "shared-subnet-1"
}

variable "subnet_2_name" {
  description = "Name tag for subnet-2"
  type        = string
  default     = "shared-subnet-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the shared VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_1_cidr" {
  description = "CIDR block for subnet-1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_2_cidr" {
  description = "CIDR block for subnet-2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "az_1" {
  description = "Availability Zone for subnet-1"
  type        = string
  default     = "us-east-1a"
}

variable "az_2" {
  description = "Availability Zone for subnet-2"
  type        = string
  default     = "us-east-1b"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instances_per_subnet" {
  description = "Number of EC2 instances per subnet"
  type        = number
  default     = 2
}
