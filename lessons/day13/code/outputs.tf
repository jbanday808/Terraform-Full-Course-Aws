output "shared_network_vpc_id" {
  description = "ID of the shared network VPC"
  value       = aws_vpc.shared_network_vpc.id
}

output "subnet_1_id" {
  description = "ID of subnet-1"
  value       = aws_subnet.subnet_1.id
}

output "subnet_2_id" {
  description = "ID of subnet-2"
  value       = aws_subnet.subnet_2.id
}

output "instance_ids" {
  description = "EC2 instance IDs"
  value       = [for i in aws_instance.shared_network_ec2 : i.id]
}

output "instance_private_ips" {
  description = "EC2 private IPs"
  value       = [for i in aws_instance.shared_network_ec2 : i.private_ip]
}
