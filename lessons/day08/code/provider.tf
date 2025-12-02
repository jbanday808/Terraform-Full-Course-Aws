# provider.tf
# AWS provider configuration (default + optional west region).

provider "aws" {
  region = "us-east-1"
}

# Optional: second region to show provider meta-argument usage
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}
