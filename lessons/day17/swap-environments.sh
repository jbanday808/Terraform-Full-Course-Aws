#!/bin/bash

#############################################
# Script: package-apps.sh
# Purpose: Perform Elastic Beanstalk
#          Blue-Green environment CNAME swap
#############################################

#############################################
# Default Configuration
#############################################

REGION="us-east-1"
BLUE_ENV=""
GREEN_ENV=""

#############################################
# Command-Line Argument Parsing
#############################################

while [[ $# -gt 0 ]]; do
  case $1 in
    --region)
      REGION="$2"
      shift 2
      ;;
    --blue)
      BLUE_ENV="$2"
      shift 2
      ;;
    --green)
      GREEN_ENV="$2"
      shift 2
      ;;
    *)
      echo "[ERROR] Unknown option: $1"
      echo "Usage: $0 [--region REGION] [--blue BLUE_ENV] [--green GREEN_ENV]"
      exit 1
      ;;
  esac
done

#############################################
# Script Header
#############################################

echo "====================================="
echo "Blue-Green Environment Swap"
echo "====================================="
echo ""

#############################################
# Retrieve Environment Names from Terraform
#############################################

if [ -z "$BLUE_ENV" ] || [ -z "$GREEN_ENV" ]; then
  echo "Retrieving environment names from Terraform outputs..."

  # Validate Terraform installation
  if ! command -v terraform &> /dev/null; then
    echo "[ERROR] Terraform is not installed or not in PATH"
    exit 1
  fi

  # Validate jq installation
  if ! command -v jq &> /dev/null; then
    echo "[ERROR] jq is not installed (required for JSON parsing)"
    echo "  Ubuntu/Debian: sudo apt-get install jq"
    echo "  macOS: brew install jq"
    exit 1
  fi

  # Fetch Terraform outputs
  TF_OUTPUT=$(terraform output -json 2>&1)
  if [ $? -ne 0 ]; then
    echo "[ERROR] Unable to read Terraform outputs"
    echo "  Run 'terraform apply' first or provide environment names manually"
    exit 1
  fi

  BLUE_ENV=$(echo "$TF_OUTPUT" | jq -r '.blue_environment_name.value')
  GREEN_ENV=$(echo "$TF_OUTPUT" | jq -r '.green_environment_name.value')

  echo "[SUCCESS] Environments detected:"
  echo "  Blue  (Production): $BLUE_ENV"
  echo "  Green (Staging):    $GREEN_ENV"
fi

#############################################
# User Confirmation
#############################################

echo ""
echo "[WARNING] This action will swap environment CNAMEs."
echo "  Production traffic will be redirected to the Green environment."
echo ""
echo "Press any key to continue or Ctrl+C to cancel..."
read -n 1 -s

#############################################
# Execute Blue-Green Swap
#############################################

echo ""
echo "Initiating environment swap..."

# Validate AWS CLI installation
if ! command -v aws &> /dev/null; then
  echo "[ERROR] AWS CLI is not installed or not in PATH"
  exit 1
fi

# Perform Elastic Beanstalk CNAME swap
if aws elasticbeanstalk swap-environment-cnames \
  --source-environment-name "$BLUE_ENV" \
  --destination-environment-name "$GREEN_ENV" \
  --region "$REGION" 2>&1; then

  ###########################################
  # Swap Success
  ###########################################

  echo ""
  echo "====================================="
  echo "[SUCCESS] Blue-Green swap initiated!"
  echo "====================================="
  echo ""
  echo "[INFO] The swap typically completes within 1–2 minutes."
  echo ""
  echo "Verification steps:"
  echo "1. Check the Elastic Beanstalk console"
  echo "2. Visit the environment URLs after a short wait"
  echo "3. Run: terraform output instructions"

else

  ###########################################
  # Swap Failure
  ###########################################

  echo ""
  echo "[ERROR] Swap failed"
  echo ""
  echo "Troubleshooting steps:"
  echo "1. Verify AWS CLI credentials and permissions"
  echo "2. Ensure both environments are healthy"
  echo "3. Confirm no other Elastic Beanstalk operation is running"
  exit 1
fi
