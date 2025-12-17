#############################################
# LOCALS.TF — Local Values (Labeled)
# Stores reusable user-data scripts for EC2
# instances in both VPCs
#############################################

locals {

  ########################
  # USER DATA — PRIMARY EC2
  ########################
  primary_user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y apache2
    systemctl enable --now apache2

    echo "<h1>Primary VPC Instance - ${var.primary_region}</h1>" > /var/www/html/index.html
    echo "<p>Private IP: $(hostname -I)</p>" >> /var/www/html/index.html
  EOF

  ########################
  # USER DATA — SECONDARY EC2
  ########################
  secondary_user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y apache2
    systemctl enable --now apache2

    echo "<h1>Secondary VPC Instance - ${var.secondary_region}</h1>" > /var/www/html/index.html
    echo "<p>Private IP: $(hostname -I)</p>" >> /var/www/html/index.html
  EOF
}
