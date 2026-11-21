ENV ?= dev
TF  := terraform

.PHONY: init plan apply configure deploy destroy recreate verify fmt validate clean

init:
	$(TF) init

fmt:
	$(TF) fmt -recursive

validate: fmt
	$(TF) init -backend=false
	$(TF) validate

plan:
	$(TF) plan -var-file=environments/$(ENV).tfvars

apply:
	$(TF) apply -var-file=environments/$(ENV).tfvars

# Full flow: infra up, then Ansible configures it
deploy: apply configure

configure:
	cd ansible && ansible-playbook playbook.yml

# The demo that proves IaC: tear everything down, then rebuild it identically
destroy:
	$(TF) destroy -var-file=environments/$(ENV).tfvars

recreate: destroy apply
	@echo "Recreated. Run 'make configure' to re-provision, or 'terraform output web_public_ips'."

verify:
	@echo "Web IPs:" && $(TF) output -json web_public_ips
	@for ip in $$($(TF) output -json web_public_ips | tr -d '[]", '); do \
	  echo "Checking http://$$ip ..."; curl -s -o /dev/null -w "%{http_code}\n" http://$$ip/ || true; \
	done

clean:
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate* ansible/inventory.ini
