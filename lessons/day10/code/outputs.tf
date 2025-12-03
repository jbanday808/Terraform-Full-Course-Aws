############################################
# Example 1 – Conditional Expression Outputs
############################################

output "conditional_instance_type" {
  description = "EC2 instance type selected based on environment (prod=t3.large, dev=t2.micro)."
  value       = aws_instance.conditional_example.instance_type
}

output "conditional_instance_id" {
  description = "EC2 instance ID created by the conditional example."
  value       = aws_instance.conditional_example.id
}

############################################
# Example 2 – Dynamic Block Outputs
############################################

output "dynamic_security_group_id" {
  description = "Security group ID created with dynamic ingress rules."
  value       = aws_security_group.dynamic_sg.id
}

output "dynamic_security_group_rules_count" {
  description = "Number of ingress rules generated from ingress_rules."
  value       = length(var.ingress_rules)
}

############################################
# Example 3 – Splat Expression Outputs
############################################

output "splat_instance_ids" {
  description = "All EC2 instance IDs from splat_example using splat expressions."
  value       = local.all_instance_ids
}

output "splat_private_ips" {
  description = "All private IPs from splat_example using splat expressions."
  value       = local.all_private_ips
}
