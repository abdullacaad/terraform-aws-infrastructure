# LocalStack — run the Terraform project with no AWS account, no card, $0

LocalStack is a fake AWS that runs on your laptop in Docker. Terraform talks
to it exactly like real AWS, so `apply` / `destroy` / `recreate` all work —
the VPC, subnets, security groups and EC2 instances are created in the mock,
then torn down again.

## What you need

- **Docker Desktop** — free, https://docs.docker.com/get-docker/
  (Windows: install Docker Desktop, start it, wait until it says "Running")
- Terraform >= 1.5 (already used for the main project)
- No AWS account, no card, no `aws configure`

## Run it (Windows PowerShell / Mac / Linux)

```powershell
cd terraform-aws-infrastructure\localstack

docker compose up -d
docker compose logs -f localstack   # wait until you see "Ready."
# (Ctrl+C to stop watching logs — LocalStack keeps running)

terraform init
terraform apply -auto-approve

terraform output
# vpc_id, subnet ids, web instance id — all created in LocalStack

terraform destroy -auto-approve
# everything gone — run apply again and it comes back identically
```

Or use the scripts (Git Bash / WSL / Mac / Linux):

```bash
./scripts/test-local.sh   # start LocalStack, apply, show outputs, destroy
```

## What is real here — and what is not

| Works in LocalStack | Does NOT work (by design) |
|---|---|
| VPC, subnets, route tables, IGW | Real EC2 boot — instances are mocked |
| Security groups | SSH into an instance (no real OS) |
| EC2 `run-instances` (fake ids/IPs) | `curl http://<ip>/` (no real Nginx) |
| `terraform plan / apply / destroy` | Ansible playbook (needs a real OS to SSH into) |

So the LocalStack demo proves the **Terraform** half: infrastructure as code,
reproducible create/destroy. The Ansible half (Nginx + Docker on a real
server) only runs on real AWS — that is why the main README keeps the two
separate, and why this folder does not pretend otherwise.

## If Docker Desktop won't start

- Make sure virtualisation is on in your BIOS (most laptops already have it).
- In Docker Desktop, check it says "Running" in the bottom-left before
  running `terraform apply` — otherwise Terraform gets "connection refused"
  on localhost:4566, which just means LocalStack isn't up yet.

## Costs

$0. LocalStack Community (the image used here) is free for EC2/VPC, and
nothing leaves your laptop.
