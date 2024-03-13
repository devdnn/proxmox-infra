proxmox_api_token_id = "root@pam!packer"  # API Token ID
proxmox_api_token_secret = "0fe3c9b0-4a82-4a6c-a2ea-d84cde42aebe"

proxmox_host      = "192.168.1.12:8006"
proxmox_node      = ["spmhampi","kishkindha-pcli"]
vmid              = 5001
cpu_type          = "kvm64"
cores             = "2"
memory            = "4096"
storage_pool      = "proxthin"
disk_size         = "8G"
disk_format       = "raw"
network_bridge    = "vmbr2"
network_vlan      = "30"

iso_url          = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso"
iso_checksum     = "33c08e56c83d13007e4a5511b9bf2c4926c4aa12fd5dd56d493c0653aecbab380988c5bf1671dbaea75c582827797d98c4a611f7fb2b131fbde2c677d5258ec9"
iso_storage_pool = "nasisos"

preseed_url_bind_address = "allweb.lo.naiduden.dev"
preseed_url_path = "/preseed/preseed-bookworm.cfg"