############################################
# ENVIRONMENT CONFIGURATION
############################################
aws_region  = "us-east-1"
environment = "dev"

############################################
# INSTANCE SETTINGS (USED IN SPLAT EXAMPLE)
############################################
instance_count = 2

############################################
# SECURITY GROUP RULES (USED IN DYNAMIC BLOCK)
############################################
ingress_rules = [

  # HTTP Access (Port 80)
  {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  },

  # HTTPS Access (Port 443)
  {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }
]
