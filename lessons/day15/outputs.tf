#############################################
# OUTPUTS.TF — VPC Peering Demo (Labeled)
# Key IDs, CIDRs, instance IPs, and a quick
# connectivity test reference
#############################################

########################
# VPC DETAILS
########################

output "primary_vpc_id" {
  description = "Primary VPC ID"
  value       = aws_vpc.primary_vpc.id
}

output "secondary_vpc_id" {
  description = "Secondary VPC ID"
  value       = aws_vpc.secondary_vpc.id
}

output "primary_vpc_cidr" {
  description = "Primary VPC CIDR block"
  value       = aws_vpc.primary_vpc.cidr_block
}

output "secondary_vpc_cidr" {
  description = "Secondary VPC CIDR block"
  value       = aws_vpc.secondary_vpc.cidr_block
}

########################
# VPC PEERING
########################

output "vpc_peering_connection_id" {
  description = "VPC peering connection ID"
  value       = aws_vpc_peering_connection.primary_to_secondary.id
}

output "vpc_peering_status" {
  description = "VPC peering connection status"
  value       = aws_vpc_peering_connection.primary_to_secondary.accept_status
}

########################
# EC2 — INSTANCE IDs
########################

output "primary_instance_id" {
  description = "Primary EC2 instance ID"
  value       = aws_instance.primary_instance.id
}

output "secondary_instance_id" {
  description = "Secondary EC2 instance ID"
  value       = aws_instance.secondary_instance.id
}

########################
# EC2 — PRIVATE IPs
########################

output "primary_instance_private_ip" {
  description = "Primary EC2 private IP"
  value       = aws_instance.primary_instance.private_ip
}

output "secondary_instance_private_ip" {
  description = "Secondary EC2 private IP"
  value       = aws_instance.secondary_instance.private_ip
}

########################
# EC2 — PUBLIC IPs
########################

output "primary_instance_public_ip" {
  description = "Primary EC2 public IP"
  value       = aws_instance.primary_instance.public_ip
}

output "secondary_instance_public_ip" {
  description = "Secondary EC2 public IP"
  value       = aws_instance.secondary_instance.public_ip
}

########################
# VALIDATION — TEST COMMANDS
########################

output "test_connectivity_command" {
  description = "Quick steps to validate VPC peering (ping over private IPs)"
  value       = <<-EOT
    Test VPC Peering (Private IP Ping)

    Option A (from Primary → Secondary):
    1) SSH:  ssh -i your-key.pem ubuntu@${aws_instance.primary_instance.public_ip}
    2) Ping: ping ${aws_instance.secondary_instance.private_ip}

    Option B (from Secondary → Primary):
    1) SSH:  ssh -i your-key.pem ubuntu@${aws_instance.secondary_instance.public_ip}
    2) Ping: ping ${aws_instance.primary_instance.private_ip}
  EOT
}
