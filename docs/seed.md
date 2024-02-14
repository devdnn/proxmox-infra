Mutable vs. Immutable in a Homelab
Mutable (Changeable)
VM/Container Configurations (settings, packages, data)
Database Contents (stored records and tables)
Network Device Configurations (on devices allowing direct changes)
Immutable (Unchangeable)
VM/Container Base Images (core OS templates)
Infrastructure as Code Definitions (Terraform, Ansible, etc.)
Network Device Configurations (ideally managed via IaC)
Benefits of Immutability
Reliability: Reduced risk of configuration issues.
Consistency: Environments stay predictable.
Recovery: Roll back or replace from known-good states.
Learning: Enforces automation best practices.
Essential Services for IaC Management
Networking
Device Config Files (via Ansible, Napalm, etc.)
IP Address Management (using IPAM solutions)
Software-defined routing (configuring routes declaratively)
DNS
Zone File Management (through tool integration or templates)
DHCP
Templated or API-driven configurations
Storage
Provisioning Volumes (iSCSI, NFS, etc.) using Terraform
Centralized Authentication (LDAP/Kerberos) integration
Monitoring & Alerting
Configuration as Code for tools like Prometheus or Zabbiz
Beyond the Basics
Application Deployment: Defining app containers/configuration.
Virtualization Management: (Proxmox with Terraform provider)
Hypervisor Config: (Limited options, vendor-specific tools)