proxmox_api_token_id = "root@pam!packer"  # API Token ID
proxmox_api_token_secret = "e6482d84-dbe3-41f0-be36-36ebfd2203ac"

proxmox_host      = "192.168.30.22:8006"
proxmox_node      = "lepakshi-lenovomini"
vmid              = "5000"
cpu_type          = "kvm64"
cores             = "2"
memory            = "4096"
storage_pool      = "vz"
disk_size         = "32G"
disk_format       = "qcow2"
network_bridge    = "vmbr0"
network_vlan      = "30"

iso_url          = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.4.0-amd64-netinst.iso"
iso_checksum     = "sha512:0262488ce2cec6d95a6c9002cfba8b81ac0d1c29fe7993aa5af30f81cecad3eb66558b9d8689a86b57bf12b8cbeab1e11d128a53356b288d48e339bb003dace5"
iso_storage_pool = "local"