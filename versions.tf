terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }

  # Local state by default — safe for learning / demo.
  # For a team / prod, uncomment the S3 backend below and create the
  # bucket + DynamoDB table first (see docs/architecture.md).
  #
  # backend "s3" {
  #   bucket         = "terraform-infra-state-<your-name>"
  #   key            = "terraform-aws-infrastructure/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-infra-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = "abdullah-saad"
    }
  }
}
