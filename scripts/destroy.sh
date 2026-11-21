#!/usr/bin/env bash
# Destroy ALL resources created by this project. Asks for confirmation.
# Usage: ./scripts/destroy.sh [dev|prod]   (default: dev)
set -euo pipefail
ENV="${1:-dev}"
cd "$(dirname "$0")/.."

echo "WARNING: this will destroy every resource in environments/$ENV.tfvars"
read -r -p "Type 'destroy' to confirm: " confirm
[ "$confirm" = "destroy" ] || { echo "Aborted."; exit 1; }

terraform destroy -var-file="environments/$ENV.tfvars" -auto-approve
echo "Destroyed. Nothing is running, nothing is billing (except any NAT in prod, now gone)."
