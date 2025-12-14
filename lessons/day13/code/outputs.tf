output "instance_id" {
  description = "ID of the EC2 instance launched into the shared EKS subnet"
  value       = aws_instance.day13_ec2.id
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.day13_ec2.private_ip
}
