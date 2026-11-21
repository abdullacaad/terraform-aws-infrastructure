variable "project_name" {
  description = "Name prefix for every resource. Keep it short, lowercase, no spaces."
  type        = string
  default     = "terraform-infra"
}

variable "environment" {
  description = "Environment name: dev or prod. Drives tags, instance counts and NAT."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be dev or prod."
  }
}

variable "aws_region" {
  description = "AWS region to deploy into. Change in environments/*.tfvars."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets (one per AZ)."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets (one per AZ)."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type. t3.micro is free-tier eligible."
  type        = string
  default     = "t3.micro"
}

variable "web_instance_count" {
  description = "Number of public web servers."
  type        = number
  default     = 1
}

variable "app_instance_count" {
  description = "Number of private app servers (no public IP)."
  type        = number
  default     = 0
}

variable "key_name" {
  description = "Existing EC2 key pair name for SSH. Leave empty to skip SSH key attachment."
  type        = string
  default     = ""
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH (port 22). Set this to YOUR IP/32 — never leave 0.0.0.0/0 in prod."
  type        = string
  default     = "0.0.0.0/0"
}

variable "ami_id" {
  description = "Fixed AMI id (LocalStack/moto only). Leave empty for real AWS — the Ubuntu AMI is looked up automatically."
  type        = string
  default     = ""
}

variable "enable_nat_gateway" {
  description = "Create a NAT Gateway so private subnets can reach the internet (for apt/yum updates). Costs ~$32/month — false by default in dev, true in prod."
  type        = bool
  default     = false
}
