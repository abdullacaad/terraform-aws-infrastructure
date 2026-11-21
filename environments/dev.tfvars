# Dev: cheapest possible — 1 web server, no app servers, no NAT.
environment        = "dev"
aws_region         = "us-east-1"
instance_type      = "t3.micro"
web_instance_count = 1
app_instance_count = 0
enable_nat_gateway = false
allowed_ssh_cidr   = "0.0.0.0/0" # TODO: replace with your IP/32
