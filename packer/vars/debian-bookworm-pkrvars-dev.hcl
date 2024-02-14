proxmox_api_token_id = "root@pam!automation"  # API Token ID
proxmox_api_token_secret = "18269805-4b67-4344-9e1c-6adae4a2f439"

proxmox_host      = "192.168.80.12:8006"
proxmox_node      = "pveopsauto"
vmid              = "5000"
cpu_type          = "kvm64"
cores             = "2"
memory            = "2048"
storage_pool      = "proxvz"
disk_size         = "8G"
disk_format       = "qcow2"
network_bridge    = "vmbr0"
network_vlan      = "80"

iso_url          = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso"
iso_checksum     = "33c08e56c83d13007e4a5511b9bf2c4926c4aa12fd5dd56d493c0653aecbab380988c5bf1671dbaea75c582827797d98c4a611f7fb2b131fbde2c677d5258ec9"
iso_storage_pool = "proxvz"