# ==============================================================================
# Network — VPC and Public Subnet (tuple + set)
# ==============================================================================

resource "aws_vpc" "main" {
  cidr_block           = local.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
      Name = "${var.environment}-vpc"
    }
  )
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.subnet_cidr
  availability_zone       = tolist(var.availability_zones)[0] # set(string)
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${var.environment}-public-subnet"
    }
  )
}

# ==============================================================================
# Security Group — Shows list, tuple, map, object usage
# ==============================================================================

resource "aws_security_group" "web_sg" {
  name        = "${var.server_config.name}-sg"  # object.name
  description = "Security group for web server"
  vpc_id      = aws_vpc.main.id

  # HTTP from tuple port (network_config[2])
  ingress {
    from_port   = var.network_config[2]
    to_port     = var.network_config[2]
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks       # list(string)
  }

  # SSH from same allowed CIDRs
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # All outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.instance_tags                     # map(string)
}

# ==============================================================================
# EC2 Instance — Pulls together all type constraints
# ==============================================================================

resource "aws_instance" "web_server" {
  # String
  ami           = "ami-0e8459476fed2e23b"
  instance_type = var.instance_type

  # Number
  count = var.instance_count

  # Bool
  monitoring                  = var.enable_monitoring
  associate_public_ip_address = var.associate_public_ip

  # Set
  availability_zone = tolist(var.availability_zones)[0]

  # Network
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Tags (map + object)
  tags = merge(
    var.instance_tags,
    {
      Name = local.instance_name
    }
  )

  # Number (storage)
  root_block_device {
    volume_size = var.storage_size
    volume_type = "gp3"
  }
}
