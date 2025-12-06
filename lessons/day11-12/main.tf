# ==============================================================================
# LABEL LEGEND (Quick Guide)
# ==============================================================================
# LABEL: Overview            → High-level description of the file or section.
# LABEL: Local               → Local variable used for formatting, processing, logic.
# LABEL: Resource            → AWS resource created by Terraform.
# LABEL: Data Source         → External AWS data Terraform reads.
# LABEL: Instructions        → Notes on how to test/modify a specific assignment.
# LABEL: Structure           → Notes about JSON structures or configuration formats.
#
# FUNCTION CATEGORY LABELS (Diagram Alignment)
# LABEL: String Function     → Uses string/text helpers (lower, replace, split, join, substr).
# LABEL: Numeric Function    → Uses math helpers (abs, max, min, sum, length for counts).
# LABEL: Collection Function → Works with lists/maps/sets (merge, concat, toset, for-expr).
# LABEL: Type Conversion     → Converts between types (tonumber, jsonencode/jsondecode).
# LABEL: File Function       → Works with files (file, fileexists, dirname).
# LABEL: Validation Function → Enforces rules (regex, can, endswith).
# LABEL: Lookup Function     → Pulls values from maps/lists safely (lookup, element).
# LABEL: Date/Time Function  → Uses timestamp/formatdate/time helpers.
# ==============================================================================


# ==============================================================================
# TERRAFORM FUNCTIONS LEARNING - AWS EDITION
# LABEL: Overview
# ==============================================================================
# This file contains 12 assignments demonstrating Terraform built-in functions.
# All assignments are enabled so you can test everything in a single apply.
# ==============================================================================


# ==============================================================================
# ASSIGNMENT 1
# LABEL: Project Naming Convention
# LABEL: String Function
# Functions: lower(), replace()
# ==============================================================================

locals {
  # LABEL: Local - formatted project name (String Function)
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
# LABEL: Collection Function
# Function: merge()
# ==============================================================================

locals {
  # LABEL: Local - merged default + environment tags (Collection Function)
  merged_tags = merge(var.default_tags, var.environment_tags)
}

resource "aws_vpc" "tagged_vpc" {
  # LABEL: Resource - VPC with merged tags
  cidr_block = "10.0.0.0/16"

  tags = local.merged_tags
}

# ------------------------------------------------------------------------------
# DEFAULT NETWORKING METADATA FOR TAGGED_VPC
# LABEL: NACL & Route Table for tagged_vpc
# ------------------------------------------------------------------------------

resource "aws_default_network_acl" "tagged_vpc_default_nacl" {
  # LABEL: Resource - default NACL for tagged_vpc
  default_network_acl_id = aws_vpc.tagged_vpc.default_network_acl_id

  # Replicate default "allow all" behavior
  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "sg-demo-nacl"
  }
}

resource "aws_default_route_table" "tagged_vpc_default_rt" {
  # LABEL: Resource - default route table for tagged_vpc
  default_route_table_id = aws_vpc.tagged_vpc.default_route_table_id

  tags = {
    Name = "sg-demo-route-table"
  }
}


# ==============================================================================
# ASSIGNMENT 3
# LABEL: S3 Bucket Naming
# LABEL: String Function
# Functions: substr(), replace(), lower()
# ==============================================================================

locals {
  # LABEL: Local - formatted bucket name (String Function)
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
# LABEL: String Function
# LABEL: Collection Function
# LABEL: Type Conversion
# Functions: split(), join(), for expression, tonumber()
# ==============================================================================

locals {
  # LABEL: Local - port list (String Function → split)
  port_list = split(",", var.allowed_ports)

  # LABEL: Local - SG rule objects (Collection Function → for-expression)
  sg_rules = [for port in local.port_list : {
    name        = "port-${port}"
    port        = port
    description = "Allow traffic on port ${port}"
  }]

  # LABEL: Local - formatted port string for docs (String + Collection Functions)
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

# ------------------------------------------------------------------------------
# DEFAULT NETWORKING METADATA FOR SG_VPC
# LABEL: NACL & Route Table for sg_vpc
# ------------------------------------------------------------------------------

resource "aws_default_network_acl" "sg_vpc_default_nacl" {
  # LABEL: Resource - default NACL for sg_vpc
  default_network_acl_id = aws_vpc.sg_vpc.default_network_acl_id

  # Allow all (default-like behavior)
  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "sg-demo-nacl"
  }
}

resource "aws_default_route_table" "sg_vpc_default_rt" {
  # LABEL: Resource - default route table for sg_vpc
  default_route_table_id = aws_vpc.sg_vpc.default_route_table_id

  tags = {
    Name = "sg-demo-route-table"
  }
}

resource "aws_security_group" "app_sg" {
  # LABEL: Resource - SG with dynamic ingress rules
  name        = "app-security-group"
  description = "Security group with dynamic ingress"
  vpc_id      = aws_vpc.sg_vpc.id

  dynamic "ingress" {
    # LABEL: Collection Function - dynamic for_each map
    for_each = { for rule in local.sg_rules : rule.name => rule }
    content {
      description = ingress.value.description
      # LABEL: Type Conversion - tonumber()
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
# SHARED NETWORKING FOR EC2 ASSIGNMENTS
# LABEL: EC2 Networking
# ==============================================================================

resource "aws_vpc" "ec2_demo_vpc" {
  # LABEL: Resource - VPC for EC2 demo instances
  cidr_block           = "10.2.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ec2-demo-vpc"
  }
}

resource "aws_subnet" "ec2_demo_subnet" {
  # LABEL: Resource - public subnet for EC2 demo
  vpc_id                  = aws_vpc.ec2_demo_vpc.id
  cidr_block              = "10.2.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "ec2-demo-subnet"
  }
}

resource "aws_security_group" "ec2_demo_sg" {
  # LABEL: Resource - EC2 demo security group
  name        = "ec2-demo-sg"
  description = "Security group for EC2 demo instances"
  vpc_id      = aws_vpc.ec2_demo_vpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-demo-sg"
  }
}

resource "aws_default_network_acl" "ec2_demo_default_nacl" {
  # LABEL: Resource - default NACL for ec2_demo_vpc
  default_network_acl_id = aws_vpc.ec2_demo_vpc.default_network_acl_id

  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "ec2-demo-nacl"
  }
}

resource "aws_default_route_table" "ec2_demo_default_rt" {
  # LABEL: Resource - default route table for ec2_demo_vpc
  default_route_table_id = aws_vpc.ec2_demo_vpc.default_route_table_id

  tags = {
    Name = "ec2-demo-route-table"
  }
}


# ==============================================================================
# ASSIGNMENT 5
# LABEL: Environment Configuration Lookup
# LABEL: Lookup Function
# Function: lookup()
# ==============================================================================

locals {
  # LABEL: Local - pick instance type per environment (Lookup Function)
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
  # LABEL: Resource - environment-sized EC2
  ami           = data.aws_ami.amazon_linux.id
  instance_type = local.instance_size

  subnet_id              = aws_subnet.ec2_demo_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_demo_sg.id]

  tags = {
    Name        = "app-server-${var.environment}"
    Environment = var.environment
    Size        = local.instance_size
  }
}


# ==============================================================================
# ASSIGNMENT 6
# LABEL: Instance Type Validation
# LABEL: Validation Function
# Functions: length(), can(), regex()
# ==============================================================================

# LABEL: Instructions - test by changing var.instance_type
# - "t"        → fails (too short)
# - "m5.large" → fails (wrong family)
# - "t2.micro" → passes

data "aws_ami" "validated_ami" {
  # LABEL: Data Source - AMI for validation test
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

  subnet_id              = aws_subnet.ec2_demo_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_demo_sg.id]

  tags = {
    Name = "validated-instance"
    Type = var.instance_type
  }
}


# ==============================================================================
# ASSIGNMENT 7
# LABEL: Backup Configuration
# LABEL: Validation Function
# Functions: endswith(), sensitive()
# ==============================================================================

locals {
  # LABEL: Local - enforce backup_name endswith() rule (double validation)
  valid_backup_name = (
    endswith(var.backup_name, "_backup")
    ? var.backup_name
    : "_invalid_backup_name"
  )

  # LABEL: Local - backup configuration object (sensitive + validated)
  backup_config = {
    name       = local.valid_backup_name
    credential = sensitive(var.credential)
    enabled    = true
  }
}


# ==============================================================================
# ASSIGNMENT 8
# LABEL: File Path Processing
# LABEL: File Function
# Functions: fileexists(), dirname(), file()
# ==============================================================================

locals {
  # LABEL: Local - config file list
  config_files = [
    "./configs/main.tf",
    "./configs/variables.tf"
  ]

  # LABEL: Local - file exists map (File Function)
  file_status = { for path in local.config_files : path => fileexists(path) }

  # LABEL: Local - directory names map (File Function)
  config_dirs = { for path in local.config_files : path => dirname(path) }
}


# ==============================================================================
# ASSIGNMENT 9
# LABEL: Resource Location Management
# LABEL: Collection Function
# Functions: toset(), concat()
# ==============================================================================

locals {
  # LABEL: Local - merged location list (Collection Function → concat)
  all_locations = concat(var.user_locations, var.default_locations)

  # LABEL: Local - unique locations (Collection Function → toset)
  unique_locations = toset(local.all_locations)
}


# ==============================================================================
# ASSIGNMENT 10
# LABEL: Cost Calculation
# LABEL: Numeric Function
# LABEL: Collection Function
# Functions: abs(), max(), min(), sum(), length(), for expression
# ==============================================================================

locals {
  # LABEL: Local - convert negative amounts to positive
  # Terraform Function: abs()
  positive_costs = [for cost in var.monthly_costs : abs(cost)]

  # LABEL: Local - highest monthly cost
  # Terraform Function: max()
  max_cost = max(local.positive_costs...)

  # LABEL: Local - lowest monthly cost
  # Terraform Function: min()
  min_cost = min(local.positive_costs...)

  # LABEL: Local - sum of all monthly costs
  # Terraform Function: sum()
  total_cost = sum(local.positive_costs)

  # LABEL: Local - average cost across all entries
  # Terraform Function: length()
  avg_cost = local.total_cost / length(local.positive_costs)
}



# ==============================================================================
# ASSIGNMENT 11
# LABEL: Timestamp Management
# LABEL: Date/Time Function
# Functions: timestamp(), formatdate()
# ==============================================================================

locals {
  # LABEL: Local - timestamp (Date/Time Function)
  current_timestamp = timestamp()

  # LABEL: Local - YYYYMMDD suffix for names (Date/Time Function)
  resource_date_suffix = formatdate("YYYYMMDD", local.current_timestamp)

  # LABEL: Local - DD-MM-YYYY for tags (Date/Time Function)
  tag_date_format = formatdate("DD-MM-YYYY", local.current_timestamp)

  # LABEL: Local - timestamped backup name (daily-backup-YYYYMMDD)
  timestamped_name = "daily-backup-${local.resource_date_suffix}"
}

resource "aws_s3_bucket" "timestamped_bucket" {
  # LABEL: Resource - timestamped backup bucket
  bucket = local.timestamped_name

  tags = {
    Name      = local.timestamped_name
    CreatedOn = local.tag_date_format
    Timestamp = local.current_timestamp
  }
}


# ==============================================================================
# ASSIGNMENT 12
# LABEL: File Content Handling
# LABEL: File Function
# LABEL: Type Conversion
# Functions: file(), fileexists(), jsondecode(), jsonencode()
# ==============================================================================

# LABEL: Structure - expected config.json
# {
#   "database": {
#     "host": "db.example.com",
#     "port": 5432,
#     "username": "admin"
#   }
# }

locals {
  # LABEL: Local - does config.json exist? (File Function)
  config_file_exists = fileexists("./config.json")

  # LABEL: Local - parsed or fallback config (File + Type Conversion)
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
  description = "App config from JSON file"

  tags = {
    Name       = "app-config"
    Sensitive  = "true"
    ConfigFile = "./config.json"
  }
}

resource "aws_secretsmanager_secret_version" "app_config_version" {
  # LABEL: Resource - secret version containing JSON config (Type Conversion → jsonencode)
  secret_id     = aws_secretsmanager_secret.app_config.id
  secret_string = jsonencode(local.config_data)
}


# ==============================================================================
# SHARED DATA SOURCES
# LABEL: Data Sources (Available for all assignments)
# ==============================================================================

data "aws_region" "current" {
  # LABEL: Data Source - current AWS region
}

data "aws_caller_identity" "current" {
  # LABEL: Data Source - current caller identity
}

data "aws_availability_zones" "available" {
  # LABEL: Data Source - available AZs in region
  state = "available"
}
