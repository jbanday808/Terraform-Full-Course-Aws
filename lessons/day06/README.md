# Day 6: File Structure

## Topics Covered
- Terraform file organization
- Sequence of file loading
- Best practices for file structure
- Code organization patterns

## Key Learning Points

### Terraform File Loading
- Terraform loads all `.tf` files in the current directory
- Files are loaded in **lexicographical order** (alphabetical)
- File names don't affect functionality, only organization
- All `.tf` files are merged into a single configuration

### Recommended File Structure
```
project-root/
├── backend.tf           # Backend configuration
├── provider.tf          # Provider configurations
├── variables.tf         # Input variable definitions
├── locals.tf           # Local value definitions
├── main.tf             # Main resource definitions
├── vpc.tf              # VPC-related resources
├── security.tf         # Security groups, NACLs
├── compute.tf          # EC2, Auto Scaling, etc.
├── storage.tf          # S3, EBS, EFS resources
├── database.tf         # RDS, DynamoDB resources
├── outputs.tf          # Output definitions
├── terraform.tfvars   # Variable values
└── README.md           # Documentation
```

### File Organization Principles
1. **Separation of Concerns**: Group related resources together
2. **Logical Grouping**: Organize by service or function
3. **Consistent Naming**: Use clear, descriptive file names
4. **Modular Approach**: Keep files focused on specific areas
5. **Documentation**: Include README and comments

## Tasks for Practice

### Task: Reorganize Previous Files
Using the files from Day 5, divide the configuration into separate files:

#### main.tf
```hcl
# main.tf
# Entry point for the Terraform configuration.
# Core resources are defined in:
# - vpc.tf      (VPC and networking)
# - storage.tf  (S3 bucket and related config)

# High-level project info
output "project_info" {
  description = "Project, environment, and region information"
  value = {
    project_name = var.project_name
    environment  = var.environment
    region       = var.region
  }
}

# Reference the S3 bucket created in storage.tf (aws_s3_bucket.main)
output "bucket_details" {
  description = "Details of the primary S3 bucket"
  value = {
    bucket_name = aws_s3_bucket.main.bucket
    bucket_arn  = aws_s3_bucket.main.arn
  }
}

# Reference the VPC created in vpc.tf (aws_vpc.main)
output "vpc_details" {
  description = "Details of the deployed VPC"
  value = {
    vpc_id   = aws_vpc.main.id
    vpc_cidr = aws_vpc.main.cidr_block
  }
}
```

#### backend.tf
```hcl
# backend.tf
# Stores Terraform state in a remote S3 bucket and uses DynamoDB for locking.

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "tf-state-backend-dev-001"
    key            = "demo/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
```

#### provider.tf
```hcl
# provider.tf
# AWS provider configuration with safe, static default tags.

provider "aws" {
  region = var.region

  # Default tags applied to every AWS resource
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  }
}
```

#### variables.tf
```hcl
# variables.tf
# Defines all input values used across the configuration.

# Environment (dev, staging, production)
variable "environment" {
  description = "Environment name (dev, staging, production)"
  type        = string
  default     = "staging"

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

# AWS Region (used by provider.tf)
variable "region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

# Project name for tagging and naming
variable "project_name" {
  description = "Name of the project"
  type        = string
}

# S3 bucket name used in storage.tf (aws_s3_bucket.main)
variable "bucket_name" {
  description = "Name of the S3 bucket to be created by storage.tf"
  type        = string
}

# VPC CIDR used in vpc.tf
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid IPv4 CIDR block."
  }
}

# Availability Zones used for public subnets in vpc.tf
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# Optional tags applied to all resources
variable "tags" {
  description = "Additional tags applied to resources"
  type        = map(string)
  default     = {}
}
```

#### locals.tf
```hcl
# locals.tf
# Reusable naming rules and team-specific tags.

locals {
  # Team / org tags only (from terraform.tfvars)
  # Environment / Project / ManagedBy now come from provider default_tags
  common_tags = var.tags

  # Standard naming pattern: project-environment
  name_prefix = "${var.project_name}-${var.environment}"

  # VPC name used in vpc.tf
  vpc_name = "${local.name_prefix}-vpc"

  # S3 bucket name from variable, used in storage.tf
  bucket_name = var.bucket_name
}
```

#### vpc.tf
```hcl
# vpc.tf
# VPC and networking resources.

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = local.vpc_name
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-igw"
  })
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-public-subnet-${count.index + 1}"
    Type = "Public"
  })
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-public-rt"
  })
}

# Associate Route Table with Public Subnets
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
```

#### storage.tf
```hcl
# storage.tf
# S3 bucket with versioning, encryption, and strict public access controls.

# S3 Bucket
resource "aws_s3_bucket" "main" {
  bucket = local.bucket_name

  tags = merge(local.common_tags, {
    Name        = local.bucket_name
    Purpose     = "General storage"
    Environment = var.environment
  })
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Server Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

#### outputs.tf
```hcl
# outputs.tf
# Key outputs for VPC, Subnets, S3, and Environment details.

# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.main.arn
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of the public subnets"
  value       = aws_subnet.public[*].cidr_block
}

# S3 Outputs
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.main.bucket
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.main.arn
}

output "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = aws_s3_bucket.main.bucket_domain_name
}

# Environment Outputs
output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "common_tags" {
  description = "Common tags applied to all resources"
  value       = local.common_tags
}
```

#### terraform.tfvars
```hcl
# Project Configuration
project_name = "aws-terraform-course"
environment  = "dev"
region       = "us-east-1"

# S3 Bucket (used in storage.tf)
bucket_name = "aws-terraform-course-demo-bucket"

# Network Configuration
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

# Optional Resource Tags
tags = {
  Owner      = "DevOps-Team"
  Department = "Engineering"
  CostCenter = "Engineering-001"
  Project    = "TerraformLearning"
}
```

### Advanced File Organization Patterns

#### Environment-Specific Structure
```
environments/
├── dev/
│   ├── backend.tf
│   ├── terraform.tfvars
│   └── main.tf
├── staging/
│   ├── backend.tf
│   ├── terraform.tfvars
│   └── main.tf
└── production/
    ├── backend.tf
    ├── terraform.tfvars
    └── main.tf

modules/
├── vpc/
├── security/
└── compute/

shared/
├── variables.tf
├── outputs.tf
└── locals.tf
```

#### Service-Based Structure
```
infrastructure/
├── networking/
│   ├── vpc.tf
│   ├── subnets.tf
│   └── routing.tf
├── security/
│   ├── security-groups.tf
│   ├── nacls.tf
│   └── iam.tf
├── compute/
│   ├── ec2.tf
│   ├── autoscaling.tf
│   └── load-balancers.tf
├── storage/
│   ├── s3.tf
│   ├── ebs.tf
│   └── efs.tf
└── data/
    ├── rds.tf
    ├── dynamodb.tf
    └── elasticache.tf
```

### Best Practices

1. **Consistent Naming**
   - Use clear, descriptive file names
   - Follow team conventions
   - Use lowercase with hyphens or underscores

2. **Logical Grouping**
   - Group related resources together
   - Separate by AWS service or function
   - Consider dependencies when organizing

3. **Size Management**
   - Keep files manageable (< 500 lines)
   - Split large files by functionality
   - Use modules for reusable components

4. **Dependencies**
   - Place provider and backend configs first
   - Define variables before using them
   - Output values at the end

5. **Documentation**
   - Include README.md
   - Comment complex configurations
   - Document variable purposes

### Commands for Testing
```bash
# Validate the reorganized structure
terraform validate

# Format all files consistently
terraform fmt -recursive

# Plan to ensure no changes
terraform plan

# Apply if everything looks good
terraform apply
```

### Common File Organization Mistakes

1. **Everything in main.tf** - Makes code hard to navigate
2. **Inconsistent naming** - Confuses team members
3. **Mixed concerns** - Resources that don't belong together
4. **No documentation** - Difficult for others to understand
5. **Overly complex structure** - Simple is often better

## Next Steps
Proceed to Day 7 to learn about Terraform type constraints and how to properly define and validate variable types.
