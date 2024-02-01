proxmox_host = "192.168.30.24:8006"
proxmox_api_token_id = "root@pam!packer"  # API Token ID
proxmox_api_token_secret = "5f754bbe-36a6-4e95-9d56-337b8e8976a1"

proxmox_node = "spmhampi"
storage_pool = "proxthin"
disk_size = "64"
disk_format = "raw"
network_bridge = "vmbr2"
network_vlan = "30"
environmenttype = "prod"

# VM Details
vm_name = "gitea-prod"
vm_description = "Gitea - Prod"
vm_ip_address = "192.168.30.42/24"
vm_gateway = "192.168.30.1"