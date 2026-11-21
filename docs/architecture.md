# Architecture

```
Internet
   |
   v
Internet Gateway
   |
   +---------------- VPC 10.0.0.0/16 (us-east-1, 2 AZs) ----------------+
   |                                                                     |
   |  Public subnets (10.0.1.0/24, 10.0.2.0/24)                          |
   |   - EC2 web x1 (dev) / x2 (prod), t3.micro, Ubuntu 22.04            |
   |   - SG web: 80/443 from 0.0.0.0/0 · SG ssh: 22 from your IP only    |
   |   - Nginx + Docker, installed by Ansible                            |
   |                                                                     |
   |  Private subnets (10.0.11.0/24, 10.0.12.0/24)                       |
   |   - EC2 app x0 (dev) / x1 (prod), no public IP                      |
   |   - SG app: 8080 only from inside the VPC                           |
   |   - NAT Gateway (prod only) for outbound updates                    |
   +---------------------------------------------------------------------+
```

## Why this layout

| Choice | Reason |
|---|---|
| 2 AZs | If one AZ fails, the other subnet/server still works — the point of a VPC. |
| Public vs private | Web servers need the internet; app servers don't. Private = smaller attack surface. |
| Modules (`modules/vpc`, `security`, `compute`) | Reusable: same modules, different `environments/*.tfvars` for dev/prod. No copy-paste. |
| AMI by data source | No hard-coded AMI ID — Terraform finds the latest Ubuntu 22.04 in any region. |
| NAT off in dev | A NAT Gateway is ~$32/month. Dev doesn't need it; prod turns it on. |
| Terraform → Ansible | `terraform apply` writes `ansible/inventory.ini` from live IPs. No hand-typed IPs. |
| Local state by default | Simple for learning. S3 backend (commented in `versions.tf`) for team/prod. |

## Cost (us-east-1, dev)

- 1× t3.micro: free-tier eligible (750 hrs/month for 12 months), then ~$7.60/month
- VPC, subnets, IGW, route tables, security groups: $0
- NAT Gateway: $0 in dev (disabled)
- EBS 8 GB gp3: ~$0.64/month

Destroy when done (`make destroy`) and the bill goes to $0.

## State

`terraform.tfstate` is local and git-ignored. For a shared/prod setup, create
an S3 bucket + DynamoDB lock table and uncomment the `backend "s3"` block in
`versions.tf`, then run `terraform init -migrate-state`.
