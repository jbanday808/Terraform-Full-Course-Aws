############################################
# Day 10 – Conditionals, Dynamic, and Splat
############################################

# Common Amazon Linux 2 AMI (latest)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

############################################
# Example 1 – Conditional Expressions
############################################

resource "aws_instance" "conditional_example" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.environment == "prod" ? "t3.large" : "t2.micro"

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

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.dynamic_sg.id]

  tags = {
    Name        = "splat-${count.index + 1}"
    Environment = var.environment
  }
}

# Locals using splat expressions
locals {
  all_instance_ids = aws_instance.splat_example[*].id
  all_private_ips  = aws_instance.splat_example[*].private_ip
}

# Outputs so you can see splat results after apply
output "splat_instance_ids" {
  description = "All instance IDs from splat_example"
  value       = local.all_instance_ids
}

output "splat_private_ips" {
  description = "All private IPs from splat_example"
  value       = local.all_private_ips
}
