resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "day13-eks-vpc"
  }
}

resource "aws_subnet" "eks_primary_subnet" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "day13-eks-primary-subnet"
  }
}

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "day13-eks-igw"
  }
}

resource "aws_route_table" "eks_public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }

  tags = {
    Name = "day13-eks-public-rt"
  }
}

resource "aws_route_table_association" "eks_public_rt_assoc" {
  subnet_id      = aws_subnet.eks_primary_subnet.id
  route_table_id = aws_route_table.eks_public_rt.id
}
