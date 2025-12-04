# Day 4: State File Management - Remote Backend

## Topics Covered
- How Terraform updates Infrastructure
- Terraform state file
- State file best practices
- Remote backend setup with S3
- S3 Native State Locking (No DynamoDB required)
- State management

## Key Learning Points

### How Terraform Updates Infrastructure
- **Goal**: Make real-world resources match your Terraform code
- **State File**:Terraform tracks real resources in terraform.tfstate
- **Process**: Compares what exists vs what you want
- **Updates**: Only changes what’s different

### Terraform State File
The state file is a JSON file that stores:
- Resource details and settings
- Resource dependencies
- Provider information
- Actual values of created resources

### State File Best Practices
1. **Never edit state file manually**
2. **Always store state remotely** (not in local file system)
3. **Lock the state to avoid conflicts**
4. **Backup state regularly**
5. **Use separate states per environment**
6. **Restrict access—contains sensitive data**
7. **Encrypt the state file at-rest and in-transit**

### Remote Backend Benefits
- **Collaboration**: Teams share a single state
- **Locking**: Prevents two people from updating at once
- **Security**: Encryption + IAM access control
- **Backup**: Automatic versioning
- **Durability**: Highly available storage

### AWS Remote Backend Components

- **S3 Bucket**: Stores the state file
- **S3 Native State Locking**: Uses S3 conditional writes (no DynamoDB)
- **IAM Policies**: Control access to backend resources

## S3 Native State Locking

### What is S3 Native State Locking?

**Terraform 1.10+** supports locking directly in S3 using conditional writes, so DynamoDB is no longer needed.

### How It Works

1. Terraform tries to create a temporary lock file
2. S3 checks if that file already exists
3. If it exists → lock fails (prevents conflicts)
4. f not → Terraform gets the lock
5. Lock file is removed when finished (shows as a delete marker)

**Previous Method (DynamoDB):**
- No extra table to manage
- Simpler IAM permissions
- Lower cost
- Recommended for all new Terraform setups


## Tasks for Practice

### Setup Remote Backend

#### Step 1: Create S3 Bucket for State Storage

Create an S3 bucket with versioning and encryption enabled to store Terraform state files.You can use the test.sh script provided in the code folder to do it quickly using AWS CLI.



### Backend Configuration Example

```hcl
terraform {
  backend "s3" {
    bucket       = "your-terraform-state-bucket"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
```

**Key Parameters:**
- `bucket`: Your S3 bucket name
- `key`: Path to store the state file
- `region`: AWS region for the S3 bucket
- `use_lockfile`: Enable S3 native state locking (set to `true`)
- `encrypt`: Enable server-side encryption for the state file



**Important:** S3 versioning MUST be enabled for S3 native state locking to work properly.



### How to Test State Locking

To verify that S3 native state locking is working:

1. **Terminal 1**: Run `terraform apply`
2. **Terminal 2**: While the first is running, try `terraform plan` or `terraform apply`
3. **Expected Result**: The second command should fail with an error like:
   ```
   Error: Error acquiring the state lock
   Error message: operation error S3: PutObject, https response error StatusCode: 412
   Lock Info:
     ID:        <lock-id>
     Path:      <bucket>/<key>
     Operation: OperationTypeApply
     Who:       <user>@<hostname>
   ```

4. **Check S3 Bucket**: During the operation, you'll see a `.tflock` file temporarily in your S3 bucket
5. **After Completion**: The lock file will be automatically deleted (delete marker with versioning)

### Backend Migration
```bash
# Initialize with new backend configuration
terraform init

# Terraform will prompt to migrate existing state
# Answer 'yes' to copy existing state to new backend

# Verify state is now remote
terraform state list
```

### State Commands
```bash
# List resources
terraform state list

# Show resource details
terraform state show <resource_name>

# RRemove from state (without destroying)
terraform state rm <resource_name>

# Move resource to different state address
terraform state mv <source> <destination>

# View full state file
terraform state pull
```

### Security Considerations

- **S3 Bucket Policy**: Restrict who can access the S3 bucket
- **S3 Versioning**: Keep S3 versioning enabled
- **Encryption**: Use server-side encryption
- **Access Logging**: nable CloudTrail logging
- **IAM Permissions**: Grant only required IAM permissions

### Common Issues

- **State Lock Error**: If terraform process crashes, the lock file may remain. Manually delete it from S3 or use: `terraform force-unlock <lock-id>`
- **Permission Errors**: Ensure proper IAM permissions for S3 operations
- **Versioning Not Enabled**: S3 versioning MUST be enabled for native state locking to work
- **Region Mismatch**: Backend region should match your provider region
- **Bucket Names**: S3 bucket names must be globally unique
- **Terraform Version**: Requires Terraform 1.10+ for S3 native locking; 1.11+ recommended for stable GA release


## Next Steps

Continue to Day 5 to learn how variables make your Terraform configurations reusable.
