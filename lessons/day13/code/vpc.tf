resource "aws_vpc" "shared_network_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.shared_vpc_name
  }
}

resource "aws_internet_gateway" "shared_igw" {
  vpc_id = aws_vpc.shared_network_vpc.id

  tags = {
    Name = "${var.shared_vpc_name}-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.shared_network_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.shared_igw.id
  }

  tags = {
    Name = "${var.shared_vpc_name}-public-rt"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.shared_network_vpc.id
  cidr_block              = var.subnet_1_cidr
  availability_zone       = var.az_1
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_1_name
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id                  = aws_vpc.shared_network_vpc.id
  cidr_block              = var.subnet_2_cidr
  availability_zone       = var.az_2
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_2_name
  }
}

resource "aws_route_table_association" "subnet_1_assoc" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "subnet_2_assoc" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}
