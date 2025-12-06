# Terraform Functions Learning Guide - AWS Edition (Day 11-12)

## 📚 Overview

This guide gives you two focused days of hands-on practice with Terraform’s most useful built-in functions. Each assignment teaches one small skill and shows exactly where you would use it in real AWS deployments.


**📋 For step-by-step walkthrough, go to [DEMO_GUIDE.md](DEMO_GUIDE.md)**

---

## 🎯 What You Will Learn

By the end of this tutorial, you will:
1. How each function works through short, practical examples
2. How to clean names, validate inputs, and format values
3. How to combine functions to build dynamic Terraform code
4. How to test anything quickly in the Terraform console
5. How to read, decode, and format file content
6. How to generate timestamps and build consistent tags
7. How to safely handle sensitive values
---

## Console Commands

Before running the assignments, test a few expressions so the functions feel familiar:

```hcl
# Basic String Manipulation
lower("HELLO WORLD")
max(5, 12, 9)
trim("  hello  ")
chomp("hello\n")
reverse(["a", "b", "c"])
```
Note: This helps you understand the output format before using functions in a full config

## 📋 Assignments Overview

| # | Assignment | Functions | Difficulty | AWS Resources |
|---|------------|-----------|------------|---------------|
| 1 | Project Naming | `lower`, `replace` | ⭐ | Standard resource names |
| 2 | Resource Tagging | `merge` | ⭐ | VPC/EC2 tags |
| 3 | S3 Bucket Naming | `substr`, `replace`, `lower` | ⭐⭐ | S3 Naming Rules |
| 4 | Security Group Ports | `split`, `join`, `for` | ⭐⭐ | Security Group |
| 5 | Environment-based Values | `lookup` | ⭐⭐ | EC2 Instance |
| 6 | Instance Validation | `length`, `can`, `regex` | ⭐⭐⭐ | EC2 Type Checks |
| 7 | Backup Rules | `endswith`, `sensitive` | ⭐⭐ | Secure Inputs |
| 8 | File Path Checks | `fileexists`, `dirname` | ⭐⭐ | Local File Validation |
| 9 | Region Merging | `toset`, `concat` | ⭐ | Remove Duplicates |
| 10 | Cost Handling | `abs`, `max`, `sum` | ⭐⭐ | Budget Logic |
| 11 | Time Formatting | `timestamp`, `formatdate` | ⭐⭐ | Tags + S3 Objects |
| 12 | Config Loading | `file`, `jsondecode` | ⭐⭐⭐ | Secrets Manager |

---

## 🚀 Quick Start

```bash
# Navigate to directory
cd /home/baivab/repos/Terraform-Full-Course-Aws/lessons/day11-12

# Initialize
terraform init

# Start with Assignment 1 (already uncommented)
terraform plan
terraform apply -auto-approve

# View outputs
terraform output

# Cleanup
terraform destroy -auto-approve
```

---

## 📖 Function Categories

### String Functions
Used to clean names and normalize text

**Functions:**`lower()`, `upper()`, `replace()`, `substr()`, `trim()`, `split()`, `join()`, `chomp()`

### Numeric Functions
Used for limits, cost logic, and comparisons

**Functions:**`abs()`, `max()`, `min()`, `ceil()`, `floor()`, `sum()`
 
### Collection Functions
Used to combine or filter lists and maps

**Functions:**`length()`, `concat()`, `merge()`, `reverse()`, `toset()`, `tolist()`

### Type Conversion
Used when Terraform expects a different type

**Functions:**`tonumber()`, `tostring()`, `tobool()`, `toset()`, `tolist()`

### File Functions
Used to read files or check if they exist

**Functions:**`file()`, `fileexists()`, `dirname()`, `basename()`

### Date/Time Functions
Used to generate clean, predictable timestamps

**Functions:**`timestamp()`, `formatdate()`, `timeadd()`art

### Validation Functions
Used to enforce naming rules or check patterns

**Functions:**`can()`, `regex()`, `contains()`, `startswith()`, `endswith()`

### Lookup Functions
Used to safely pull values from lists and maps

**Functions:**`lookup()`, `element()`, `index()`

---

## 📁 Files

- `README.md` - This overview
- `DEMO_GUIDE.md` - The step-by-step walkthrough you follow
- `provider.tf` - AWS provider and region configuration
- `backend.tf` - Optional S3 remote backend
- `variables.tf` - Variables for each assignment
- `main.tf` - All 12 assignments (uncomment one at a time)
- `outputs.tf` - Outputs for each assignment


---

## ✅ Assignment Summary

### Assignment 1: Project Naming ⭐
Convert messy project names into AWS-friendly slugs

**Functions:** `lower()`, `replace()`  
**Status:** ✅ Active by default

### Assignment 2: Resource Tagging ⭐
Combine default tags with environment-specific tags

**Function:** `merge()`

### Assignment 3: S3 Bucket Naming ⭐⭐
Make bucket names lowercase, short, and fully compliant

**Functions:** `substr()`, `replace()`, `lower()`

### Assignment 4: Security Group Ports ⭐⭐
Turn a comma-separated list into structured SG rule inputs

**Functions:** `split()`, `join()`, `for`

### Assignment 5: Environment Lookup ⭐⭐
Pick the correct instance type based on environment

**Function:** `lookup()`

### Assignment 6: Instance Validation ⭐⭐⭐
Check that instance types follow AWS naming patterns

**Functions:** `length()`, `can()`, `regex()`

### Assignment 7: Backup Configuration ⭐⭐
Make sure backup names end correctly and protect values

**Functions:** `endswith()`, `sensitive`

### Assignment 8: File Path Processing ⭐⭐
Check if a file exists and extract the parent folder

**Functions:** `fileexists()`, `dirname()`

### Assignment 9: Location Management ⭐
Combine multiple region lists and remove duplicates

**Functions:** `toset()`, `concat()`

### Assignment 10: Cost Calculation ⭐⭐
Add costs together and apply credits safely

**Functions:** `abs()`, `max()`, `sum()`

### Assignment 11: Timestamp Management ⭐⭐
Generate formatted timestamps for tags and S3 objects

**Functions:** `timestamp()`, `formatdate()`

### Assignment 12: File Content Handling ⭐⭐⭐
Load a JSON config, decode it, and prepare it for Secrets Manager

**Functions:** `file()`, `jsondecode()`, `jsonencode()`

---


---

## 📚 Helpful Resources

- [Terraform Functions Docs](https://www.terraform.io/language/functions)
- [Terraform Console](https://www.terraform.io/cli/commands/console)
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [DEMO_GUIDE.md](DEMO_GUIDE.md) - Complete demo instructions

---

## 🚀 Next Steps

Continue Day 13: Terraform Workspaces, where you separate dev, test, and prod environments.

---

**Happy Learning! 🎉**
