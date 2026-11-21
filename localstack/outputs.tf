output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "web_public_ips" {
  description = "Fake IPs from LocalStack — the instances are mocked, so there is no real server to curl or SSH into. See README.md."
  value       = module.compute.web_public_ips
}

output "web_instance_ids" {
  value = module.compute.web_instance_ids
}
