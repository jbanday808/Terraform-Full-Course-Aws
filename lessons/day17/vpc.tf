#############################################
# VPC for Elastic Beanstalk (No Default VPC)
#############################################

# Get available AZs in the region
data "aws_availability_zones" "available" {
  state = "available"
}

#############################################
# VPC
#############################################

resource "aws_vpc" "eb_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = "${var.app_name}-vpc"
  })
}

#############################################
# Internet Gateway
#############################################

resource "aws_internet_gateway" "eb_igw" {
  vpc_id = aws_vpc.eb_vpc.id

  tags = merge(var.tags, {
    Name = "${var.app_name}-igw"
  })
}

#############################################
# Public Subnets (2 AZs)
#############################################

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.eb_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.app_name}-public-a"
    Tier = "public"
  })
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.eb_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.app_name}-public-b"
    Tier = "public"
  })
}

#############################################
# Public Route Table + Default Route
#############################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eb_vpc.id

  tags = merge(var.tags, {
    Name = "${var.app_name}-public-rt"
  })
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.eb_igw.id
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

#############################################
# Outputs (optional but helpful)
#############################################

output "vpc_id" {
  description = "VPC ID for Elastic Beanstalk"
  value       = aws_vpc.eb_vpc.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs (use these for Elastic Beanstalk env settings)"
  value       = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}
