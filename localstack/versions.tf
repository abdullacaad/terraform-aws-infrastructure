terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# LocalStack provider: same AWS provider, pointed at localhost:4566,
# with dummy credentials and all real-AWS checks skipped.
# These are NOT real credentials — "test"/"test" is the LocalStack convention.
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://localhost:4566"
  }

  default_tags {
    tags = {
      Project     = "terraform-infra"
      Environment = "local"
      ManagedBy   = "terraform"
    }
  }
}
