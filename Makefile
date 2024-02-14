SHELL := /bin/bash
PATH := $(PATH)

# distro string
OS_VERSION_NAME := $(shell lsb_release -cs)

HOSTNAME = $(shell hostname)

LOCAL_BIN = $(shell echo $$HOME/.local/bin)

VARIABLES = '{"users": [{"username": "$(shell whoami)"}], "ansible_user": "$(shell whoami)", "docker_users": ["$(shell whoami)"]}'

env ?= dev
create_gitea_vm ?= false

help:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  help: Show this help message"
	@echo "  build: Build the project"
	@echo "  run: Run the project"
	@echo "  clean: Clean the project"

hello:
	echo $(VARIABLES.users.username)


# packer debian validate
packer-init-debian:
	echo "Init for plugin installation"
	cd packer && packer init ./base-debian-bookworm

packer-validate-debian:
	echo "Validating a Debian VM Template in $(env) environment"
	cd packer && packer validate -var-file vars/debian-bookworm-pkrvars-$(env).hcl ./base-debian-bookworm

packer-create-debian-template:
	echo "Creating a Debian VM Template in $(env) environment"
	cd packer && packer build -force -var-file vars/debian-bookworm-pkrvars-$(env).hcl ./base-debian-bookworm

#region gitea with postgresql
gitea-setup-configure:
ifeq ($(create_gitea_vm), true)
		echo "Creating Gitea VM with PostgreSQL in $(env) environment";
		make gitea-terraform;
else
		echo "Skipping VM creation for Gitea with PostgreSQL in $(env) environment";
endif
	make gitea-postgresql-ansible
	make gitea-ansible

gitea-terraform:
	echo "Creating terraform VM for Gitea with PostgreSQL in $(env) environment"
	cd terraform && cd gitea && terraform init && terraform apply -var-file ./vars/gitea-pkrvars-$(env).tfvars -auto-approve

gitea-postgresql-ansible:
	echo "Running ansible playbook for PostgreSQL in $(env) environment"
	cd ansible && ansible-playbook -i inventories/$(env) playbooks/setup-postgresql.yml -k -K -e @../global_vars/$(env).yml

gitea-ansible:
	echo "Running ansible playbook for Gitea in $(env) environment"
	cd ansible && ansible-playbook -i inventories/$(env) playbooks/setup-gitea.yml -k -K -e @../global_vars/$(env).yml

gitea-destroy-terraform:
	echo "Destroying terraform VM for Gitea with PostgreSQL in $(env) environment"
	cd terraform && cd gitea && terraform init && terraform destroy -var-file ./vars/gitea-pkrvars-$(env).tfvars -auto-approve
#endregion

# region Setup and configure infrastructure
setup-configure-validate-terraform:
	echo "Setting up and configuring infrastructure in $(env) environment"
	cd terraform && cd $(env) && cd infra && terraform init && terraform validate

setup-configure-plan-terraform:
	echo "Setting up and configuring infrastructure in $(env) environment"
	cd terraform && cd $(env) && cd infra && terraform init && terraform validate && terraform plan

setup-configure-apply-terraform:
	echo "Setting up and configuring infrastructure in $(env) environment"
	cd terraform && cd $(env) && cd infra && terraform apply -auto-approve
# endregion Setup and configure ifrastructure