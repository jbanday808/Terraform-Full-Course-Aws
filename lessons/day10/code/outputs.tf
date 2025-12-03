############################################
# Outputs – All Demos Active
############################################

# Demo 1 – Conditional Expression
output "conditional_instance_type" {
  description = "Instance type selected using conditional expression."
  value       = aws_instance.conditional_example.instance_type
}

output "conditional_instance_id" {
  description = "ID of the conditional demo instance."
  value       = aws_instance.conditional_example.id
}

# Demo 2 – Dynamic Block
output "dynamic_security_group_id" {
  description = "Security group ID created with dynamic ingress rules."
  value       = aws_security_group.dynamic_sg.id
}

output "dynamic_security_group_rules_count" {
  description = "Number of ingress rules created dynamically."
  value       = length(var.ingress_rules)
}

# Demo 3 – Splat Expressions
output "splat_instance_ids" {
  description = "List of instance IDs created by splat example."
  value       = local.all_instance_ids
}

output "splat_private_ips" {
  description = "List of private IPs created by splat example."
  value       = local.all_private_ips
}
