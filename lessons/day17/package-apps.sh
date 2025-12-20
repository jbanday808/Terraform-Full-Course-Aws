#!/bin/bash

#############################################
# Script: package-apps.sh
# Purpose: Package application versions for
#          Elastic Beanstalk Blue-Green deployment
#############################################

#############################################
# Script Header
#############################################

echo "====================================="
echo "Packaging Applications for Deployment"
echo "====================================="
echo ""

#############################################
# Package Application Version 1.0 (Blue)
#############################################

echo "Packaging Application v1.0 (Blue)..."

cd app-v1 || exit 1

# Remove existing package if present
if [ -f "app-v1.zip" ]; then
  rm -f app-v1.zip
fi

# Create deployment package
zip -q app-v1.zip app.js package.json

echo "[SUCCESS] Created app-v1/app-v1.zip"

# Return to project root
cd ..

echo ""

#############################################
# Package Application Version 2.0 (Green)
#############################################

echo "Packaging Application v2.0 (Green)..."

cd app-v2 || exit 1

# Remove existing package if present
if [ -f "app-v2.zip" ]; then
  rm -f app-v2.zip
fi

# Create deployment package
zip -q app-v2.zip app.js package.json

echo "[SUCCESS] Created app-v2/app-v2.zip"

# Return to project root
cd ..

echo ""

#############################################
# Script Completion
#############################################

echo "====================================="
echo "[SUCCESS] All applications packaged successfully!"
echo "====================================="
echo ""

#############################################
# Next Steps
#############################################

echo "Next steps:"
echo "1. Run: terraform init"
echo "2. Run: terraform plan"
echo "3. Run: terraform apply"
