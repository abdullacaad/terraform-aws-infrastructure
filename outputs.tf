output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC."
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = module.vpc.private_subnet_ids
}

output "web_public_ips" {
  description = "Public IPs of the web servers — open http://<ip> to see Nginx."
  value       = module.compute.web_public_ips
}

output "web_public_dns" {
  description = "Public DNS names of the web servers."
  value       = module.compute.web_public_dns
}

output "app_private_ips" {
  description = "Private IPs of the app servers (no public IP by design)."
  value       = module.compute.app_private_ips
}

output "web_security_group_id" {
  value = module.security.web_security_group_id
}

output "ssh_command" {
  description = "Example SSH command (only if a key pair was set)."
  value       = length(module.compute.web_public_ips) > 0 ? "ssh -i ~/.ssh/${var.key_name}.pem ubuntu@${module.compute.web_public_ips[0]}" : "Set var.key_name, then re-apply to get an SSH command."
}

output "destroy_recreate_note" {
  description = "How to prove the infra is reproducible."
  value       = "Run: make destroy && make apply — the same code recreates identical infra. See docs/destroy-recreate-demo.md"
}
