# LocalStack root — reuses the SAME modules as real AWS (../modules/*).
# Only the provider (versions.tf) and the AMI change. If it works here,
# the same code works on real AWS — that is the point of the demo.
#
# LocalStack's EC2 mock has no real AZ list, so we use fixed AZ names
# instead of the aws_availability_zones data source used in the real root.

module "vpc" {
  source = "../modules/vpc"

  project_name         = "terraform-infra"
  environment          = "local"
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  enable_nat_gateway   = false
}

module "security" {
  source = "../modules/security"

  project_name     = "terraform-infra"
  environment      = "local"
  vpc_id           = module.vpc.vpc_id
  vpc_cidr         = "10.0.0.0/16"
  allowed_ssh_cidr = "0.0.0.0/0"
}

module "compute" {
  source = "../modules/compute"

  project_name       = "terraform-infra"
  environment        = "local"
  instance_type      = "t3.micro"
  web_instance_count = 1
  app_instance_count = 0
  key_name           = ""
  # LocalStack accepts any AMI id — there is no real Ubuntu image to boot.
  ami_id             = "ami-12345678"
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  web_security_group_ids = [
    module.security.web_security_group_id,
    module.security.ssh_security_group_id,
  ]
  app_security_group_ids = [
    module.security.app_security_group_id,
    module.security.ssh_security_group_id,
  ]
}
