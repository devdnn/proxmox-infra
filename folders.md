# Ansible Project Structure

This document outlines the folder structure of our Ansible project.

## Directory Layout

```plaintext
ansible-project/
│
├── inventory/
│   └── hosts.yml                # Inventory file in YAML format
│
├── group_vars/
│   ├── all.yml                  # Global variables applied to all hosts
│   ├── web_servers.yml          # Variables specific to the 'web_servers' group
│   └── db_servers.yml           # Variables specific to the 'db_servers' group
│
├── host_vars/
│   ├── server1.example.com.yml  # Variables specific to 'server1.example.com'
│   └── server2.example.com.yml  # Variables specific to 'server2.example.com'
│
├── vars/
│   └── global.yml               # Alternative place for global variables
│
├── roles/
│   ├── common/                  # A common role applied to all hosts
│   │   ├── tasks/
│   │   ├── handlers/
│   │   ├── templates/
│   │   ├── files/
│   │   ├── vars/
│   │   └── defaults/
│   ├── webserver/               # Role for web server configuration
│   └── database/                # Role for database server configuration
│
├── playbooks/
│   ├── site.yml                 # Main playbook that includes other playbooks
│   ├── web.yml                  # Playbook for web server setup
│   └── db.yml                   # Playbook for database server setup
│
└── ansible.cfg                  # Ansible configuration file
```

## Kubernetes folder structure

```plaintext
my-kubernetes-project/
│
├── packer/
│   └── debian_bookworm/
│       ├── debian_bookworm.json  # Packer JSON template for Debian Bookworm
│       └── scripts/              # Provisioning scripts for Debian Bookworm
│
├── ansible/
│   ├── roles/
│   │   ├── gitea/                # Role for Gitea setup
│   │   │   ├── tasks/            # Tasks for Gitea
│   │   │   ├── handlers/         # Handlers for Gitea
│   │   │   ├── templates/        # Templates for Gitea (like gitea.ini.j2)
│   │   │   └── vars/             # Variables for Gitea
│   │   │
│   │   └── postgresql/           # Role for PostgreSQL setup
│   │       ├── tasks/            # Tasks for PostgreSQL
│   │       ├── handlers/         # Handlers for PostgreSQL
│   │       ├── templates/        # Templates for PostgreSQL (like pg_hba.conf.j2)
│   │       └── vars/             # Variables for PostgreSQL
│   │
│   ├── playbooks/                # Ansible playbooks
│   │   ├── setup_gitea.yml       # Playbook for setting up Gitea
│   │   └── setup_postgres.yml    # Playbook for setting up PostgreSQL
│   │
│   └── inventory/                # Ansible inventory files
│
└── terraform/                    # Terraform configurations
    ├── modules/                  # Reusable Terraform modules
    ├── prod/                     # Production environment configurations
    │   ├── main.hcl              # Main Terraform file for production
    │   ├── variables.hcl         # Variables for production
    │   └── outputs.hcl           # Outputs for production
    └── staging/                  # Staging environment configurations
        ├── main.hcl              # Main Terraform file for staging
        ├── variables.hcl         # Variables for staging
```
