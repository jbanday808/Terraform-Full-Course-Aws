# Day 3: S3 Bucket

## What You Learn
- How AWS verifies who you are (authentication)
- How to create and manage an S3 bucket for secure cloud storage
  
## Simple Breakdown

### AWS Authentication
Terraform needs valid AWS credentials before it can create anything, so you must configure authentication first.

### Authentication Methods
1. **AWS CLI Setup**: `aws configure`
2. **Environment Variables**: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
3. **IAM Roles**: Used by EC2 or AWS services
4. **AWS Profiles**: Switch between multiple accounts
   
### S3 (Simple Storage Service)
A secure, scalable service for storing files, logs, backups, and application data.

## Tasks for Practice

### Prerequisites
1. **Create AWS Account**: Sign up for AWS free tier if you don't have an account
2. **Install AWS CLI**: Download and install from AWS official website
3. **Configure Credentials**: Set up your AWS access keys

#### AWS CLI Installation

**Check your system architecture first:**
```bash
# Linux/macOS
uname -m

# Windows PowerShell
$env:PROCESSOR_ARCHITECTURE
```

**Official Website**: https://aws.amazon.com/cli/

**Windows:**
```powershell
# Using MSI installer (recommended)
# Download from: https://awscli.amazonaws.com/AWSCLIV2.msi

# Using winget
winget install Amazon.AWSCLI

# Using chocolatey
choco install awscli
```

**macOS:**
```bash
# Using official installer
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

# Using Homebrew
brew install awscli
```

**Ubuntu/Debian:**
```bash
# Update package index
sudo apt update

# Install AWS CLI v2 (choose based on your architecture)
# For x86_64
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# For ARM64
curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"

unzip awscliv2.zip
sudo ./aws/install

# Verify installation
aws --version
```

### Authentication Setup

#### Method 1: AWS CLI Configuration
```bash
aws configure
```
You will enter:
- AWS Access Key ID
- AWS Secret Access Key
- Default region (e.g., us-east-1)
- Default output format (json)

#### Method 2: Environment Variables
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### Tasks to Complete
1. **Explore the Terraform AWS provider docs (S3 section)**
   - Visit: https://registry.terraform.io/providers/hashicorp/aws/latest
   - Explore S3 resource documentation

2. **Create an S3 bucket using Terraform**
   - S3 bucket with unique name

3. **Run Terraform commands to init, plan, apply, and verify your bucket in the AWS Console**

### Important Notes
- **Resource Names**: S3 bucket names must be globally unique
- **Regions**: Always check you're working in your intended AWS region
- **Costs**: Monitor costs, even when using free-tier
- **Cleanup**: Destroy resources when done

### Common Commands
```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan changes
terraform plan

# Apply changes
terraform apply

# Show current state
terraform show

# Destroy resources
terraform destroy
```

### Troubleshooting Tips
- Ensure AWS credentials are configured correctly
- Verify your region matches your setup
- Use unique bucket names
- Check AWS CloudTrail logs for API activity if needed

## Next Steps
Continue to Day 4 to learn about Terraform state file management and remote backends using S3 and DynamoDB.
