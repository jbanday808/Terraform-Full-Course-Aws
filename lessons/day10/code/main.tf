############################################
# Day 10 – Terraform Expressions Demo
# Conditional, Dynamic, and Splat Examples
############################################

############################################
# Data Source – Latest Amazon Linux 2 AMI
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
# Example 1 – Conditional Expression
############################################

resource "aws_instance" "conditional_example" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.environment == "prod" ? "t3.large" : "t2.micro"

  # Use existing subnet if provided, otherwise the demo subnet
  subnet_id              = coalesce(var.subnet_id, aws_subnet.public.id)
  vpc_security_group_ids = [aws_security_group.dynamic_sg.id]

  tags = {
    Name        = "conditional-${var.environment}"
    Environment = var.environment
  }
}

############################################
# Example 2 – Dynamic Security Group Rules
############################################

resource "aws_security_group" "dynamic_sg" {
  name        = "dynamic-sg-${var.environment}"
  description = "Security group with dynamic ingress rules"

  # Use existing VPC if provided, otherwise the demo VPC
  vpc_id = coalesce(var.vpc_id, aws_vpc.demo.id)

  # Dynamic ingress rules pulled from var.ingress_rules
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

  # Allow all outbound by default
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "dynamic-sg-${var.environment}"
    Environment = var.environment
  }
}

############################################
# Example 3 – Splat Expressions
############################################

resource "aws_instance" "splat_example" {
  count = var.instance_count

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  # Use existing subnet if provided, otherwise the demo subnet
  subnet_id              = coalesce(var.subnet_id, aws_subnet.public.id)
  vpc_security_group_ids = [aws_security_group.dynamic_sg.id]

  tags = {
    Name        = "splat-${count.index + 1}"
    Environment = var.environment
  }
}

############################################
# Locals – Splat Extracted Values
############################################

locals {
  all_instance_ids = aws_instance.splat_example[*].id
  all_private_ips  = aws_instance.splat_example[*].private_ip
}
