# Day 9: Terraform Lifecycle Meta-arguments (AWS)

## 📚 Topics Covered
- `create_before_destroy` - Zero-downtime deployments
- `prevent_destroy` - Protect critical resources
- `ignore_changes` - Ignore external modifications
- `replace_triggered_by` - Dependency-based replacements
- `precondition` - Validate before deployment
- `postcondition` - Validate after deployment
---

## 🎯 Learning Objectives

By the end of this lesson, you will:
1. Understand each lifecycle meta-argument
2. Know when to apply the right rule
3. Protect production and stateful resources
4. Deploy changes without downtime
5. Work safely with externally modified resources
6. Validate configurations before and after creation

## 🔧 Lifecycle Meta-arguments Explained

### 1. create_before_destroy

**What it does:**  
Creates the new resource first, then removes the old one.

**Default Behavior:**  
Destroy first → create second.

**Use Cases:**
- ✅ EC2 instances behind load balancers
- ✅ RDS instances with read replicas
- ✅ High-availability infrastructure
- ✅ Resources supporting other components

**Example:**
```hcl
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true
  }
}
```

**Benefits:**
- ✅ No downtime
- ✅ Smooth updates
- ✅ Lower deployment risk
- ✅ Supports blue-green strategies

**When NOT to use:**
- ❌ Naming must stay constant
- ❌ Downtime is acceptable
- ❌ Duplicate resources increase cost

---

### 2. prevent_destroy

**What it does:**  
Blocks deletion attempts; Terraform will stop with an error.

**Use Cases:**
- ✅ Production databases
- ✅ S3 buckets storing critical data
- ✅ Key security groups
- ✅ Compliance-controlled resources

**Example:**
```hcl
resource "aws_s3_bucket" "critical_data" {
  bucket = "my-critical-production-data"

  lifecycle {
    prevent_destroy = true
  }
}
```

**Benefits:**
- ✅ Prevents accidental deletion
- ✅ Protects data and state
- ✅ Prevents data loss
- ✅ Enforces manual review
  
**How to Remove:**
1. Comment out `prevent_destroy = true`
2. Run `terraform apply` to update the state
3. Destroy if needed
   
**When to use:**
- ✅ Production databases
- ✅ State files storage
- ✅ Compliance-required resources
- ✅ Resources with important data

---

### 3. ignore_changes

**What it does:**  
Instructs Terraform to ignore specified attribute updates.

**Use Cases:**
- ✅ Auto Scaling Group capacity (managed by auto-scaling policies)
- ✅ EC2 instance tags (added by monitoring tools)
- ✅ Security group rules (managed by other teams)
- ✅ Database passwords (managed via Secrets Manager)

**Example:**
```hcl
resource "aws_autoscaling_group" "app_servers" {
  # ... other configuration ...
  
  desired_capacity = 2

  lifecycle {
    ignore_changes = [
      desired_capacity,  # Ignore capacity changes by auto-scaling
      load_balancers,    # Ignore if added externally
    ]
  }
}
```

**Special Values:**
- `ignore_changes = all` - Ignore ALL attribute changes
- `ignore_changes = [tags]` - Ignore only tags

**Benefits:**
- ✅ Prevents configuration drift issues
- ✅ Allows external systems to manage certain attributes
- ✅ Reduces Terraform plan noise
- ✅ Enables hybrid management approaches

**When to use:**
- ✅ Resources modified by auto-scaling
- ✅ Attributes managed by external tools
- ✅ Frequently changing values
- ✅ Values managed outside Terraform

---

### 4. replace_triggered_by

**What it does:**  
Forces resource replacement when specified dependencies change, even if the resource itself hasn't changed.

**Use Cases:**
- ✅ Replace EC2 instances when security groups change
- ✅ Recreate containers when configuration changes
- ✅ Force rotation of resources based on other resource updates

**Example:**
```hcl
resource "aws_security_group" "app_sg" {
  name = "app-security-group"
  # ... security rules ...
}

resource "aws_instance" "app_with_sg" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  lifecycle {
    replace_triggered_by = [
      aws_security_group.app_sg.id  # Replace instance when SG changes
    ]
  }
}
```

**Benefits:**
- ✅ Guarantees consistency
- ✅ Ensures fresh deployments
- ✅ Supports immutable patterns
  
**When to use:**
- ✅ When dependent resource changes require recreation
- ✅ For immutable infrastructure patterns
- ✅ When you want forced resource rotation

---

### 5. precondition

**What it does:**  
Validates conditions BEFORE Terraform attempts to create or update a resource. Errors if condition is false.

**Use Cases:**
- ✅ Validate deployment region is allowed
- ✅ Ensure required tags are present
- ✅ Check environment variables before deployment
- ✅ Validate configuration parameters

**Example:**
```hcl
resource "aws_s3_bucket" "regional_validation" {
  bucket = "validated-region-bucket"

  lifecycle {
    precondition {
      condition     = contains(var.allowed_regions, data.aws_region.current.name)
      error_message = "ERROR: Can only deploy in allowed regions: ${join(", ", var.allowed_regions)}"
    }
  }
}
```

**Benefits:**
- ✅ Catches errors before resource creation
- ✅ Enforces organizational policies
- ✅ Provides clear error messages
- ✅ Prevents invalid configurations

**When to use:**
- ✅ Enforce compliance requirements
- ✅ Validate inputs before deployment
- ✅ Ensure dependencies are met
- ✅ Check environment constraints

---

### 6. postcondition

**What it does:**  
Validates conditions AFTER Terraform creates or updates a resource. Errors if condition is false.

**Use Cases:**
- ✅ Ensure required tags exist after creation
- ✅ Validate resource attributes are correctly set
- ✅ Check resource state after deployment
- ✅ Verify compliance after creation

**Example:**
```hcl
resource "aws_s3_bucket" "compliance_bucket" {
  bucket = "compliance-bucket"

  tags = {
    Environment = "production"
    Compliance  = "SOC2"
  }

  lifecycle {
    postcondition {
      condition     = contains(keys(self.tags), "Compliance")
      error_message = "ERROR: Bucket must have a 'Compliance' tag!"
    }

    postcondition {
      condition     = contains(keys(self.tags), "Environment")
      error_message = "ERROR: Bucket must have an 'Environment' tag!"
    }
  }
}
```

**Benefits:**
- ✅ Verifies resource was created correctly
- ✅ Ensures compliance after deployment
- ✅ Catches configuration issues post-creation
- ✅ Validates resource state

**When to use:**
- ✅ Verify resource meets requirements after creation
- ✅ Ensure tags or attributes are set correctly
- ✅ Check resource state post-deployment
- ✅ Validate compliance requirements


## Common Patterns

### Pattern 1: Database Protection
Combine create_before_destroy + prevent_destroy.

### Pattern 2: Auto-Scaling Integration
Use ignore_changes for ASG-managed values.

### Pattern 3: Immutable Infrastructure
Use replace_triggered_by to force rebuilds on config change.

## Best Practices
- Use create_before_destroy for high-availability workloads
- Protect critical data with prevent_destroy
- Document all lifecycle customizations
- Test lifecycle behavior in development
- Use ignore_changes carefully to avoid missing real issues

- Forgetting dependencies when using create_before_destroy
- Over-using ignore_changes and missing important updates
- Not testing lifecycle rules before applying to production

## Next Steps
Continue to Day 10 to explore Dynamic Blocks and Expressions for cleaner, more flexible Terraform configurations.
