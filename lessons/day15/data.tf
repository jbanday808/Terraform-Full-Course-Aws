#############################################
# DATA.TF — Data Sources (Labeled)
# Centralized lookups for AZs and AMIs used
# across the VPC Peering demo
#############################################

########################
# AVAILABILITY ZONES
########################

# Primary Region — Available AZs
data "aws_availability_zones" "primary" {
  provider = aws.primary
  state    = "available"

  tags = {
    Purpose = "AZ-Lookup"
    Region  = "Primary"
    Scope   = "VPC-Peering-Demo"
  }
}

# Secondary Region — Available AZs
data "aws_availability_zones" "secondary" {
  provider = aws.secondary
  state    = "available"

  tags = {
    Purpose = "AZ-Lookup"
    Region  = "Secondary"
    Scope   = "VPC-Peering-Demo"
  }
}

########################
# AMAZON MACHINE IMAGES
########################

# Primary Region — Ubuntu 24.04 LTS AMI
data "aws_ami" "primary_ami" {
  provider    = aws.primary
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  tags = {
    OS          = "Ubuntu-24.04-LTS"
    Region      = "Primary"
    Purpose     = "EC2-AMI-Lookup"
    Environment = "Demo"
  }
}

# Secondary Region — Ubuntu 24.04 LTS AMI
data "aws_ami" "secondary_ami" {
  provider    = aws.secondary
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  tags = {
    OS          = "Ubuntu-24.04-LTS"
    Region      = "Secondary"
    Purpose     = "EC2-AMI-Lookup"
    Environment = "Demo"
  }
}
