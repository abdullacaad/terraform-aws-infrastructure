# Proof — LocalStack run on Abdullah's laptop, 2026-11-21

Run live on Windows, Docker Desktop 4.99.0 / Engine 29.9.3, Terraform v1.9.8.
No AWS account, no card, $0.

## 1. LocalStack started

```
docker compose up -d
[+] up 28/28
 ✔ Image localstack/localstack:3.8 Pulled
 ✔ Network localstack_default Created
 ✔ Container terraform-localstack Started
```

## 2. Apply — 16 added

```
terraform init
# AWS provider 5.100.0 installed, "Terraform has been successfully initialized!"

terraform apply -auto-approve
# Apply complete! Resources: 16 added, 0 changed, 0 destroyed.

Outputs:
  vpc_id = "vpc-c173ce97"
  web_instance_ids = ["i-b427fa8793cc4d0a9"]
  web_public_ips = ["54.214.43.98"]
  public_subnet_ids = ["subnet-f589edbb", "subnet-7fe147a7"]
  private_subnet_ids = ["subnet-7b68d8bc", "subnet-c6d71de5"]
```

The public IP is a LocalStack fake IP — there is no real server behind it,
so it is not presented as a live website.

## 3. Destroy — 16 destroyed

```
terraform destroy -auto-approve
# Destroy complete! Resources: 16 destroyed.
```

Screenshot: `screenshots/03-destroy-complete.png`

## 4. LocalStack stopped

```
docker compose down
# Container terraform-localstack Removed
# Network localstack_default Removed
```

## What this proves

The same Terraform code creates and deletes the full VPC / subnet /
security-group / EC2 setup, reproducibly, with no manual clicks and no bill.
