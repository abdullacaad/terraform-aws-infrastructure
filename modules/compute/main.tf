# Latest Ubuntu 22.04 LTS (Canonical) for the chosen region — no hard-coded AMI.
# Skipped entirely when var.ami_id is set (LocalStack / moto: there is no
# Canonical AMI to look up, so a fixed fake AMI id is used instead).
data "aws_ami" "ubuntu" {
  count       = var.ami_id == "" ? 1 : 0
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  ami_id = var.ami_id != "" ? var.ami_id : data.aws_ami.ubuntu[0].id
}

# Public web servers — spread across the public subnets (round-robin by index).
resource "aws_instance" "web" {
  count                  = var.web_instance_count
  ami                    = local.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[count.index % length(var.public_subnet_ids)]
  vpc_security_group_ids = var.web_security_group_ids
  key_name               = var.key_name == "" ? null : var.key_name

  # Minimal bootstrap so Ansible can connect: Python is all Ansible needs.
  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y python3
  EOF

  tags = {
    Name = "${var.project_name}-${var.environment}-web-${count.index + 1}"
    Role = "web"
    Tier = "public"
  }
}

# Private app servers — no public IP, only reachable from inside the VPC.
resource "aws_instance" "app" {
  count                  = var.app_instance_count
  ami                    = local.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids = var.app_security_group_ids
  key_name               = var.key_name == "" ? null : var.key_name

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y python3
  EOF

  tags = {
    Name = "${var.project_name}-${var.environment}-app-${count.index + 1}"
    Role = "app"
    Tier = "private"
  }
}
