############################################
# DAY 10 – TERRAFORM EXPRESSIONS DEMO
# Includes:
#   • Conditional Expressions
#   • Dynamic Blocks
#   • Splat Expressions
############################################


############################################
# DATA SOURCES
# (Latest Amazon Linux 2 AMI)
############################################

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


############################################
# EXAMPLE 1 – CONDITIONAL EXPRESSION
# Decision-making expression:
#   If prod → t3.large
#   Else    → t2.micro
############################################

resource "aws_instance" "conditional_example" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.environment == "prod" ? "t3.large" : "t2.micro"

  # Use existing subnet if provided, otherwise use demo subnet (fallback)
  subnet_id              = coalesce(var.subnet_id, aws_subnet.public.id)
  vpc_security_group_ids = [aws_security_group.dynamic_sg.id]

  tags = {
    Name        = "conditional-${var.environment}"
    Environment = var.environment
    Project     = "Day10-Terraform-Expressions-Demo"
  }
}


############################################
# EXAMPLE 2 – DYNAMIC BLOCKS
# Automatically builds multiple ingress rules
# based on the ingress_rules variable list.
############################################

resource "aws_security_group" "dynamic_sg" {
  name        = "dynamic-sg-${var.environment}"
  description = "Security group with dynamic ingress rules"

  # Use existing VPC if provided, otherwise use demo VPC
  vpc_id = coalesce(var.vpc_id, aws_vpc.demo.id)

  # Dynamic ingress rule generator
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  # Default outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "dynamic-sg-${var.environment}"
    Environment = var.environment
    Project     = "Day10-Terraform-Expressions-Demo"
  }
}


############################################
# EXAMPLE 3 – SPLAT EXPRESSIONS
# Creates multiple instances and extracts:
#   • All instance IDs
#   • All private IPs
############################################

resource "aws_instance" "splat_example" {
  count = var.instance_count

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  # Use existing subnet if provided, otherwise use demo subnet
  subnet_id              = coalesce(var.subnet_id, aws_subnet.public.id)
  vpc_security_group_ids = [aws_security_group.dynamic_sg.id]

  tags = {
    Name        = "splat-${count.index + 1}"
    Environment = var.environment
    Project     = "Day10-Terraform-Expressions-Demo"
  }
}


############################################
# LOCAL VALUES – EXTRACTING SPLAT RESULTS
# Collects all instance IDs and IPs into lists.
############################################

locals {
  all_instance_ids = aws_instance.splat_example[*].id
  all_private_ips  = aws_instance.splat_example[*].private_ip
}
