environmenttype = "dev"

# host node proxmox details
proxmox_api_endpoint_url = "https://192.168.80.12:8006/"
proxmox_api_user         = "root@pam"
proxmox_api_password     = "Kites123"
proxmox_tls_insecure     = true
proxmox_node             = "pveopsauto"

storage_pool     = "proxvz"
interface_bridge = "vmbr0"

template_file_location_id = "proxvz:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"


