# Prod: 2 web servers across 2 AZs, 1 private app server, NAT on.
environment        = "prod"
aws_region         = "us-east-1"
instance_type      = "t3.micro"
web_instance_count = 2
app_instance_count = 1
enable_nat_gateway = true
allowed_ssh_cidr   = "0.0.0.0/0" # TODO: replace with your IP/32 — never ship this
