# ==============================
# Data Sources
# ==============================

# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Get current AWS region
data "aws_region" "current" {}

# Get availability zones in the current region
data "aws_availability_zones" "available" {
  state = "available"
}

# ==============================
# Networking: Demo VPC for EC2, ASG, and Security Group
# ==============================

resource "aws_vpc" "demo" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.resource_tags,
    {
      Name = "lifecycle-demo-vpc"
    }
  )
}

resource "aws_internet_gateway" "demo" {
  vpc_id = aws_vpc.demo.id

  tags = merge(
    var.resource_tags,
    {
      Name = "lifecycle-demo-igw"
    }
  )
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = cidrsubnet(aws_vpc.demo.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.resource_tags,
    {
      Name = "lifecycle-demo-public-${count.index}"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo.id
  }

  tags = merge(
    var.resource_tags,
    {
      Name = "lifecycle-demo-public-rt"
    }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ==============================
# Example 1: create_before_destroy
# Use Case: EC2 instance that needs zero downtime during updates
# ==============================

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.resource_tags,
    {
      Name = var.instance_name
      Demo = "create_before_destroy"
    }
  )

  # Lifecycle: create a new instance before destroying the old one
  lifecycle {
    create_before_destroy = true
  }
}

# ==============================
# Example 2: prevent_destroy
# Use Case: Critical S3 bucket that should not be deleted by mistake
# ==============================

resource "aws_s3_bucket" "critical_data" {
  bucket = "day09-demo-lifecycle-001-critical-${var.environment}-${data.aws_region.current.name}"

  tags = merge(
    var.resource_tags,
    {
      Name       = "Critical Production Data Bucket"
      Demo       = "prevent_destroy"
      DataType   = "Critical"
      Compliance = "Required"
    }
  )

  # Lifecycle: protect this bucket from accidental deletion
  lifecycle {
    # prevent_destroy = true  # Uncomment in real production to block deletion
  }
}

# Enable versioning on the critical bucket
resource "aws_s3_bucket_versioning" "critical_data" {
  bucket = aws_s3_bucket.critical_data.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ==============================
# Example 3: ignore_changes
# Use Case: Auto Scaling Group where capacity is managed externally
# ==============================

# Launch Template for Auto Scaling Group
resource "aws_launch_template" "app_server" {
  name_prefix   = "app-server-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.resource_tags,
      {
        Name = "App Server from ASG"
        Demo = "ignore_changes"
      }
    )
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app_servers" {
  name              = "app-servers-asg"
  min_size          = 1
  max_size          = 5
  desired_capacity  = 2
  health_check_type = "EC2"

  # Use subnets in our demo VPC instead of default VPC
  vpc_zone_identifier = [for subnet in aws_subnet.public : subnet.id]

  launch_template {
    id      = aws_launch_template.app_server.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "App Server ASG"
    propagate_at_launch = true
  }

  tag {
    key                 = "Demo"
    value               = "ignore_changes"
    propagate_at_launch = false
  }

  # Lifecycle: ignore desired_capacity changes made by auto-scaling
  lifecycle {
    ignore_changes = [
      desired_capacity,
      # load_balancers, # Uncomment if external tools attach load balancers
    ]
  }
}

# ==============================
# Example 4: precondition
# Use Case: Ensure we deploy only in allowed regions
# ==============================

resource "aws_s3_bucket" "regional_validation" {
  bucket = "day09-demo-lifecycle-001-validated-${var.environment}-${data.aws_region.current.name}"

  tags = merge(
    var.resource_tags,
    {
      Name = "Region Validated Bucket"
      Demo = "precondition"
    }
  )

  # Lifecycle: validate region before creating the bucket
  lifecycle {
    precondition {
      condition     = contains(var.allowed_regions, data.aws_region.current.name)
      error_message = "ERROR: This resource can only be created in allowed regions: ${join(", ", var.allowed_regions)}. Current region: ${data.aws_region.current.name}"
    }
  }
}

# ==============================
# Example 5: postcondition
# Use Case: Ensure S3 bucket has required tags after creation
# ==============================

resource "aws_s3_bucket" "compliance_bucket" {
  bucket = "day09-demo-lifecycle-001-compliance-${var.environment}-${data.aws_region.current.name}"

  tags = merge(
    var.resource_tags,
    {
      Name       = "Compliance Validated Bucket"
      Demo       = "postcondition"
      Compliance = "SOC2"
    }
  )

  # Lifecycle: verify required tags exist after bucket creation
  lifecycle {
    postcondition {
      condition     = contains(keys(self.tags), "Compliance")
      error_message = "ERROR: Bucket must have a 'Compliance' tag for audit purposes!"
    }

    postcondition {
      condition     = contains(keys(self.tags), "Environment")
      error_message = "ERROR: Bucket must have an 'Environment' tag!"
    }
  }
}

# ==============================
# Example 6: replace_triggered_by
# Use Case: Replace EC2 instances when security group changes
# ==============================

# Security Group
resource "aws_security_group" "app_sg" {
  name        = "app-security-group"
  description = "Security group for application servers"
  vpc_id      = aws_vpc.demo.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.resource_tags,
    {
      Name = "App Security Group"
      Demo = "replace_triggered_by"
    }
  )
}

# EC2 Instance that gets replaced when security group changes
resource "aws_instance" "app_with_sg" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = merge(
    var.resource_tags,
    {
      Name = "App Instance with Security Group"
      Demo = "replace_triggered_by"
    }
  )

  # Lifecycle: replace instance when security group changes
  lifecycle {
    replace_triggered_by = [
      aws_security_group.app_sg.id
    ]
  }
}

# ==============================
# Example 7: Multiple S3 Buckets with create_before_destroy
# Use Case: Managing multiple buckets from a set
# ==============================

resource "aws_s3_bucket" "app_buckets" {
  for_each = var.bucket_names

  bucket = "${each.value}-${var.environment}-${data.aws_region.current.name}"

  tags = merge(
    var.resource_tags,
    {
      Name   = each.value
      Demo   = "for_each_with_lifecycle"
      Bucket = each.key
    }
  )

  # Lifecycle: create new bucket before destroying the old one
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      # acl, # Uncomment if ACLs are managed elsewhere
    ]
  }
}

# ==============================
# Example 8: Combining Multiple Lifecycle Rules
# Use Case: DynamoDB table with comprehensive protections
# ==============================

resource "aws_dynamodb_table" "critical_app_data" {
  name         = "${var.environment}-app-data-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = merge(
    var.resource_tags,
    {
      Name        = "Critical Application Data"
      Demo        = "multiple_lifecycle_rules"
      DataType    = "Critical"
      Environment = var.environment
    }
  )

  # Multiple lifecycle rules combined for protection and validation
  lifecycle {
    # Protect from accidental deletion (enable in real prod)
    # prevent_destroy = true

    # Zero-downtime recreation if needed
    create_before_destroy = true

    # Allow AWS to manage capacity if using auto-scaling
    ignore_changes = [
      # read_capacity,
      # write_capacity,
    ]

    # Validate tags before creation
    precondition {
      condition     = contains(keys(var.resource_tags), "Environment")
      error_message = "Critical table must have Environment tag for compliance!"
    }

    # Validate billing mode after creation
    postcondition {
      condition     = self.billing_mode == "PAY_PER_REQUEST" || self.billing_mode == "PROVISIONED"
      error_message = "Billing mode must be either PAY_PER_REQUEST or PROVISIONED!"
    }
  }
}
