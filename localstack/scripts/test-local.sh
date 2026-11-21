#!/usr/bin/env bash
# Full LocalStack demo: start mock AWS, apply, show outputs, destroy.
# Usage (from the localstack/ folder): ./scripts/test-local.sh
set -euo pipefail
cd "$(dirname "$0")/.."

echo "== Starting LocalStack =="
docker compose up -d
echo "Waiting for LocalStack on http://localhost:4566 ..."
for i in $(seq 1 60); do
  if curl -sf http://localhost:4566/_localstack/health >/dev/null 2>&1; then
    echo "LocalStack is ready."
    break
  fi
  sleep 2
done

echo "== terraform init =="
terraform init -input=false
echo "== terraform apply =="
terraform apply -auto-approve -input=false
echo "== outputs =="
terraform output
echo "== terraform destroy =="
terraform destroy -auto-approve -input=false
echo
echo "Done. Apply again any time with: terraform apply -auto-approve"
echo "Stop LocalStack with: docker compose down"
