# LocalStack notes (for the portfolio / interview)

## Why LocalStack exists in this repo

Abdullah has no payment card, and AWS requires a card even for the Free Tier,
so a real AWS account cannot be created right now. The Terraform code is
still real and still validated — LocalStack lets the same code be *executed*
with no account, no card and no bill.

## How it works

- `localstack/` is a second Terraform root. It imports the same
  `modules/vpc`, `modules/security` and `modules/compute` as the real root.
- Only two things change: the provider points at `http://localhost:4566`
  with dummy credentials, and the compute module gets a fixed fake AMI
  (`ami-12345678`) instead of looking up Ubuntu — LocalStack has no
  Canonical AMI catalogue.
- The compute module supports this via `var.ami_id` (empty = look up the
  real Ubuntu AMI, set = use the given id). The real-AWS root passes
  `ami_id = ""` by default, so it is unchanged.

## Honest limits

LocalStack EC2 instances are mocked: they get ids and IPs in the state, but
there is no real operating system behind them. So there is no SSH, no
`curl` to a live Nginx page, and the Ansible playbook does not run here.
That is stated in `localstack/README.md`, not hidden — claiming a live
web server from a mock would be inventing a result.
