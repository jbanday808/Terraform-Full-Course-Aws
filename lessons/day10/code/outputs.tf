############################################
# OUTPUTS – DAY 10 TERRAFORM EXPRESSIONS DEMO
# Includes: Conditional, Dynamic, and Splat
############################################

############################################
# DEMO 1 – CONDITIONAL EXPRESSION OUTPUTS
############################################

output "conditional_instance_type" {
  description = "Instance type selected using the conditional expression (dev=t2.micro, prod=t3.large)."
  value       = aws_instance.conditional_example.instance_type
}

output "conditional_instance_id" {
  description = "EC2 instance ID created by the conditional expression demo."
  value       = aws_instance.conditional_example.id
}

############################################
# DEMO 2 – DYNAMIC BLOCK OUTPUTS
############################################

output "dynamic_security_group_id" {
  description = "Security group ID created using dynamic ingress rules."
  value       = aws_security_group.dynamic_sg.id
}

output "dynamic_security_group_rules_count" {
  description = "Total number of dynamic ingress rules added to the security group."
  value       = length(var.ingress_rules)
}

############################################
# DEMO 3 – SPLAT EXPRESSION OUTPUTS
############################################

output "splat_instance_ids" {
  description = "List of instance IDs created from the splat example."
  value       = local.all_instance_ids
}

output "splat_private_ips" {
  description = "List of private IP addresses for all splat-created instances."
  value       = local.all_private_ips
}
