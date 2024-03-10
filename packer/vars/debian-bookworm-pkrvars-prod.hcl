proxmox_api_token_id = "root@pam!packer"  # API Token ID
proxmox_api_token_secret = "5f754bbe-36a6-4e95-9d56-337b8e8976a1"

proxmox_host      = "192.168.30.11:8006"
proxmox_node      = "spmhampi"
vmid              = "5000"
cpu_type          = "kvm64"
cores             = "2"
memory            = "4096"
storage_pool      = "nasvmdrives"
disk_size         = "8G"
disk_format       = "qcow2"
network_bridge    = "vmbr2"
network_vlan      = "30"

iso_url          = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso"
iso_checksum     = "33c08e56c83d13007e4a5511b9bf2c4926c4aa12fd5dd56d493c0653aecbab380988c5bf1671dbaea75c582827797d98c4a611f7fb2b131fbde2c677d5258ec9"
iso_storage_pool = "nasisos"