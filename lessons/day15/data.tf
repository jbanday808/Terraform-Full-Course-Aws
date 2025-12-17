#############################################
# DATA.TF — Data Sources (Corrected)
# Lookups for AZs and AMIs used by the
# VPC Peering demo
#############################################

########################
# AVAILABILITY ZONES
########################

# Primary Region — Available AZs
data "aws_availability_zones" "primary" {
  provider = aws.primary
  state    = "available"
}

# Secondary Region — Available AZs
data "aws_availability_zones" "secondary" {
  provider = aws.secondary
  state    = "available"
}

########################
# AMAZON MACHINE IMAGES
########################

# Primary Region — Ubuntu 24.04 LTS
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
}

# Secondary Region — Ubuntu 24.04 LTS
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
}
