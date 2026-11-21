#!/usr/bin/env bash
# Deploy: Terraform up, then Ansible configures the servers.
# Usage: ./scripts/deploy.sh [dev|prod]   (default: dev)
set -euo pipefail
ENV="${1:-dev}"
cd "$(dirname "$0")/.."

echo "== Terraform init =="
terraform init
echo "== Terraform apply ($ENV) =="
terraform apply -var-file="environments/$ENV.tfvars" -auto-approve
echo "== Ansible configure =="
cd ansible && ansible-playbook playbook.yml
cd ..
echo
echo "Done. Web IPs:"
terraform output web_public_ips
