############################################
# NETWORK LAYER – VPC CREATION
############################################

resource "aws_vpc" "demo" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "day10-demo-vpc"
    Environment = var.environment
    Project     = "Day10-Terraform-Expressions-Demo"
  }
}

############################################
# SUBNET – PUBLIC SUBNET FOR EC2 & DEMOS
############################################

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "day10-demo-subnet-public"
    Environment = var.environment
    Project     = "Day10-Terraform-Expressions-Demo"
  }
}

############################################
# INTERNET GATEWAY – PUBLIC INTERNET ACCESS
############################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name        = "day10-demo-igw"
    Environment = var.environment
    Project     = "Day10-Terraform-Expressions-Demo"
  }
}

############################################
# ROUTING – PUBLIC ROUTE TABLE
############################################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name        = "day10-demo-route-table-public"
    Environment = var.environment
    Project     = "Day10-Terraform-Expressions-Demo"
  }
}

############################################
# ROUTE – DEFAULT INTERNET ROUTE (0.0.0.0/0)
############################################

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

############################################
# ASSOCIATION – LINK SUBNET TO ROUTE TABLE
############################################

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

############################################
# OPTIONAL OUTPUTS – HELPFUL FOR DEBUGGING
############################################

output "demo_vpc_id" {
  description = "ID of the Day 10 demo VPC."
  value       = aws_vpc.demo.id
}

output "demo_public_subnet_id" {
  description = "ID of the Day 10 public subnet."
  value       = aws_subnet.public.id
}
