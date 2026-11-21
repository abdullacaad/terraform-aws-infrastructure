#!/usr/bin/env bash
# Recreate demo: destroy everything, then rebuild it identically.
# This is the proof that the infrastructure is code, not manual clicks.
# Usage: ./scripts/recreate.sh [dev|prod]   (default: dev)
set -euo pipefail
ENV="${1:-dev}"
cd "$(dirname "$0")/.."

echo "== Step 1/2: destroy ($ENV) =="
terraform destroy -var-file="environments/$ENV.tfvars" -auto-approve
echo "== Step 2/2: apply ($ENV) =="
terraform apply -var-file="environments/$ENV.tfvars" -auto-approve
echo "== Re-provision with Ansible =="
cd ansible && ansible-playbook playbook.yml
cd ..
echo
echo "Recreated. Same code, fresh infrastructure:"
terraform output web_public_ips
