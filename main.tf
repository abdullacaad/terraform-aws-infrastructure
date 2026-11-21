# ---------------------------------------------------------------------------
# Automated Cloud Infrastructure with Terraform
# VPC (2 AZs) -> public + private subnets -> EC2 (web + app) -> Ansible
# ---------------------------------------------------------------------------

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  # Use the first two AZs in the region, so the same code works in any region.
  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = local.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
}

module "security" {
  source = "./modules/security"

  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.vpc.vpc_id
  vpc_cidr         = var.vpc_cidr
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

module "compute" {
  source = "./modules/compute"

  project_name       = var.project_name
  environment        = var.environment
  instance_type      = var.instance_type
  web_instance_count = var.web_instance_count
  app_instance_count = var.app_instance_count
  key_name           = var.key_name
  ami_id             = var.ami_id
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

# --- Terraform -> Ansible handoff -------------------------------------------
# Generates ansible/inventory.ini from the live EC2 IPs, so Ansible never
# needs a hand-typed IP. Re-generated on every `terraform apply`.
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/ansible/inventory.ini.tftpl", {
    web_ips  = module.compute.web_public_ips
    app_ips  = module.compute.app_private_ips
    ssh_user = "ubuntu"
    key_path = var.key_name == "" ? "~/.ssh/id_rsa" : "~/.ssh/${var.key_name}.pem"
  })
  filename        = "${path.module}/ansible/inventory.ini"
  file_permission = "0644"
}
