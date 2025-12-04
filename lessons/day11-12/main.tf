# ==============================================================================
# LABEL LEGEND (Quick Guide)
# ==============================================================================
# LABEL: Overview        → High-level description of the file or section.
# LABEL: Local           → Local variable used for logic/formatting.
# LABEL: Resource        → AWS resource created by Terraform.
# LABEL: Data Source     → AWS information Terraform reads.
# LABEL: Instructions    → How to test or modify behavior.
# LABEL: Structure       → JSON/config format notes.
# ==============================================================================


# ==============================================================================
# TERRAFORM FUNCTIONS LEARNING - AWS EDITION
# LABEL: Overview
# ==============================================================================
# All 12 assignments are enabled simultaneously.
# Great for learning and testing all Terraform functions at once.
# ==============================================================================


# ==============================================================================
# ASSIGNMENT 1
# LABEL: Project Naming Convention
# Functions: lower(), replace()
# ==============================================================================

locals {
  # LABEL: Local - formatted project name
  formatted_project_name = lower(replace(var.project_name, " ", "-"))
}

resource "aws_resourcegroups_group" "project" {
  # LABEL: Resource - project resource group
  name = local.formatted_project_name

  resource_query {
    query = jsonencode({
      ResourceTypeFilters = ["AWS::AllSupported"]
      TagFilters = [{
        Key    = "Project"
        Values = [local.formatted_project_name]
      }]
    })
  }

  tags = {
    Name    = local.formatted_project_name
    Project = local.formatted_project_name
  }
}


# ==============================================================================
# ASSIGNMENT 2
# LABEL: Resource Tagging
# Function: merge()
# ==============================================================================

locals {
  # LABEL: Local - merged tags
  merged_tags = merge(var.default_tags, var.environment_tags)
}

resource "aws_vpc" "tagged_vpc" {
  # LABEL: Resource - VPC with merged tags
  cidr_block = "10.0.0.0/16"
  tags       = local.merged_tags
}


# ==============================================================================
# ASSIGNMENT 3
# LABEL: S3 Bucket Naming
# Functions: substr(), replace(), lower()
# ==============================================================================

locals {
  # LABEL: Local - formatted bucket name
  formatted_bucket_name = replace(
    replace(
      lower(substr(var.bucket_name, 0, 63)),
      " ", ""
    ),
    "!", ""
  )
}

resource "aws_s3_bucket" "storage" {
  # LABEL: Resource - S3 bucket
  bucket = local.formatted_bucket_name

  tags = {
    Name        = local.formatted_bucket_name
    Environment = var.environment
  }
}


# ==============================================================================
# ASSIGNMENT 4
# LABEL: Security Group Port Configuration
# Functions: split(), join(), for expression
# ==============================================================================

locals {
  # LABEL: Local - list of ports
  port_list = split(",", var.allowed_ports)

  # LABEL: Local - SG rule objects
  sg_rules = [for port in local.port_list : {
    name        = "port-${port}"
    port        = port
    description = "Allow traffic on port ${port}"
  }]

  # LABEL: Local - documentation formatted ports
  formatted_ports = join("-", [for port in local.port_list : "port-${port}"])
}

resource "aws_vpc" "sg_vpc" {
  # LABEL: Resource - VPC for SG demo
  cidr_block = "10.1.0.0/16"

  tags = {
    Name       = "security-group-demo-vpc"
    Assignment = "4"
  }
}

resource "aws_security_group" "app_sg" {
  # LABEL: Resource - dynamic SG rules
  name        = "app-security-group"
  description = "Security group with dynamic ports"
  vpc_id      = aws_vpc.sg_vpc.id

  dynamic "ingress" {
    for_each = { for rule in local.sg_rules : rule.name => rule }
    content {
      description = ingress.value.description
      from_port   = tonumber(ingress.value.port)
      to_port     = tonumber(ingress.value.port)
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-security-group"
  }
}


# ==============================================================================
# ASSIGNMENT 5
# LABEL: Environment Configuration Lookup
# Function: lookup()
# ==============================================================================

locals {
  # LABEL: Local - selected instance size
  instance_size = lookup(var.instance_sizes, var.environment, "t2.micro")
}

data "aws_ami" "amazon_linux" {
  # LABEL: Data Source - Amazon Linux 2 AMI
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "app_server" {
  # LABEL: Resource - app server instance
  ami           = data.aws_ami.amazon_linux.id
  instance_type = local.instance_size

  tags = {
    Name        = "app-server-${var.environment}"
    Environment = var.environment
    Size        = local.instance_size
  }
}


# ==============================================================================
# ASSIGNMENT 6
# LABEL: Instance Type Validation
# ==============================================================================

data "aws_ami" "validated_ami" {
  # LABEL: Data Source - AMI for validated instance
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "validated_instance" {
  # LABEL: Resource - validated instance
  ami           = data.aws_ami.validated_ami.id
  instance_type = var.instance_type

  tags = {
    Name = "validated-instance"
    Type = var.instance_type
  }
}


# ==============================================================================
# ASSIGNMENT 7
# LABEL: Backup Configuration
# ==============================================================================

locals {
  # LABEL: Local - backup config object
  backup_config = {
    name       = var.backup_name
    credential = var.credential
    enabled    = true
  }
}


# ==============================================================================
# ASSIGNMENT 8
# LABEL: File Path Processing
# ==============================================================================

locals {
  # LABEL: Local - config file list
  config_files = [
    "./configs/main.tf",
    "./configs/variables.tf"
  ]

  # LABEL: Local - file exists check
  file_status = { for path in local.config_files : path => fileexists(path) }

  # LABEL: Local - directory names
  config_dirs = { for path in local.config_files : path => dirname(path) }
}


# ==============================================================================
# ASSIGNMENT 9
# LABEL: Resource Location Management
# ==============================================================================

locals {
  # LABEL: Local - merged list
  all_locations = concat(var.user_locations, var.default_locations)

  # LABEL: Local - unique set
  unique_locations = toset(local.all_locations)
}


# ==============================================================================
# ASSIGNMENT 10
# LABEL: Cost Calculation
# ==============================================================================

locals {
  # LABEL: Local - convert negative values
  positive_costs = [for cost in var.monthly_costs : abs(cost)]

  # LABEL: Local - highest cost
  max_cost = max(local.positive_costs...)

  # LABEL: Local - total cost
  total_cost = sum(local.positive_costs)

  # LABEL: Local - average cost
  avg_cost = local.total_cost / length(local.positive_costs)
}


# ==============================================================================
# ASSIGNMENT 11
# LABEL: Timestamp Management
# ==============================================================================

locals {
  # LABEL: Local - timestamp
  current_timestamp = timestamp()

  # LABEL: Local - YYYYMMDD suffix
  resource_date_suffix = formatdate("YYYYMMDD", local.current_timestamp)

  # LABEL: Local - DD-MM-YYYY tag
  tag_date_format = formatdate("DD-MM-YYYY", local.current_timestamp)

  # LABEL: Local - timestamped name
  timestamped_name = "backup-${local.resource_date_suffix}"
}

resource "aws_s3_bucket" "timestamped_bucket" {
  # LABEL: Resource - timestamped bucket
  bucket = "my-backup-${local.resource_date_suffix}"

  tags = {
    Name      = local.timestamped_name
    CreatedOn = local.tag_date_format
    Timestamp = local.current_timestamp
  }
}


# ==============================================================================
# ASSIGNMENT 12
# LABEL: File Content Handling
# ==============================================================================

locals {
  # LABEL: Local - does config.json exist?
  config_file_exists = fileexists("./config.json")

  # LABEL: Local - parsed or fallback config
  config_data = local.config_file_exists ? jsondecode(file("./config.json")) : {
    database = {
      host     = "localhost"
      port     = 5432
      username = "default"
    }
  }
}

resource "aws_secretsmanager_secret" "app_config" {
  # LABEL: Resource - secret container
  name        = "app-configuration-${formatdate("YYYYMMDD-hhmm", timestamp())}"
  description = "Application configuration from file"

  tags = {
    Name       = "app-config"
    Sensitive  = "true"
    ConfigFile = "./config.json"
  }
}

resource "aws_secretsmanager_secret_version" "app_config_version" {
  # LABEL: Resource - secret version
  secret_id     = aws_secretsmanager_secret.app_config.id
  secret_string = jsonencode(local.config_data)
}


# ==============================================================================
# SHARED DATA SOURCES
# LABEL: Data Sources
# ==============================================================================

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}
