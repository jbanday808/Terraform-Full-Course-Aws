# Day 1: Introduction to Terraform

## What You’ll Learn
- What Infrastructure as Code (IaC) means
- Why teams use IaC
- What Terraform is and why it’s useful
- Problems with traditional manual setup
- The Terraform workflow
- How to install Terraform

## Key Ideas

### What is Infrastructure as Code?
Using code to build and manage cloud resources so everything stays consistent, repeatable, and automated.

### Why Infrastructure as Code Matters?
- **Consistency**: Ensures identical environments across development, testing, and production
- **Time Efficiency**: Speeds up deployments through automation
- **Cost Management**: Makes it easier to track usage, control spending, and automate cleanup
- **Scalability**: Lets you deploy hundreds of resources with the same effort as deploying one
- **Version Control**: Captures every change in Git for better visibility and rollback
- **Reduced Human Error**: Removes manual steps that often cause misconfigurations
- **Collaboration**: Allows teams to work together on shared, code-driven infrastructure

### Benefits of IaC
- Consistent, repeatable environment builds
- Clear cost tracking and optimization
- “Write once, deploy everywhere” simplicity
- Faster deployments with full automation
- Fewer misconfigurations
- Version-controlled infrastructure changes
- Automated cleanup and scheduled teardown
- Developers focus more on application work
- Easy recreation of production environments for troubleshooting

### What is Terraform?
Infrastructure as Code tool that uses code to create, update, and destroy infrastructure across AWS, Azure, GCP, and more.

### How Terraform Works
Write Terraform files → Run Terraform commands → Call AWS APIs through Terraform Provider

**Terraform Workflow Phases:**
1. `terraform init` - Prepare the working directory
2. `terraform validate` - Check the configuration for errors
3. `terraform plan` - Preview what Terraform will create or update
4. `terraform apply` - Build the infrastructure
5. `terraform destroy` - Remove all resources when no longer needed
   
## Tasks for Practice

### Install Terraform
Follow the installation guide: https://developer.hashicorp.com/terraform/install

or 

### Common Installation Commands
```bash
# For macOS
brew install hashicorp/tap/terraform

# For Ubuntu/Debian
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

### Setup Commands
```bash
terraform -install-autocomplete
alias tf=terraform
terraform -version
```

### Common Installation Error (macOS)
If you see:
```
Error: No developer tools installed.
```
Install Command Line Tools:
```bash
xcode-select --install
```

## Next Steps
Move to Day 2 to explore Terraform Providers and how they connect Terraform to AWS.
