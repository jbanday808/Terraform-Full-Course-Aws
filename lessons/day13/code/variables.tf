variable "region" {
  description = "AWS region where the shared EKS VPC and resources exist"
  type        = string
  default     = "us-east-1"
}

variable "eks_vpc_name" {
  description = "Tag name of the existing shared EKS VPC"
  type        = string
  default     = "shared-eks-vpc"
}

variable "eks_subnet_name" {
  description = "Tag name of the existing shared EKS subnet"
  type        = string
  default     = "shared-eks-primary-subnet"
}
