environmenttype = "dev"

# host node proxmox details
proxmox_api_endpoint_url = "https://192.168.30.22:8006/api2/json"
proxmox_node = "lepakshi-lenovomini"
proxmox_api_user = "root@pam"
proxmox_api_password = "Float12345678"
proxmox_tls_insecure = true

# storage settings
template_file_location_id = "nasios:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"
proxmox_storage_pool = "proxthin"
os_storage_disk_size = "8"
postgresql_disk_size = "16G"
kea_disk_size = "50G"

# memory settings
new_lxc_memory = "2048"
new_lxc_swap_memory = "1024"


# new host details
new_hostname_prefix = "dev"
new_hostname = "kea-dhcp-02"
new_lxc_description = "DHCP Server with kea and postgresql"
new_lxc_os_type = "debian"

# network settings
new_lcx_dns_interface_bridge = "vmbr0"
new_lcx_dns_interface_bridge_temp = "vmbr2"
new_lxc_kea_dns_ip_CIDR = "192.168.30.81/24"
new_lxc_dns_gateway = "192.168.30.1"
new_lxc_kea_dns_ip_CIDR_temp = "192.168.1.1/24"
new_lxc_dns_gateway_temp = "192.168.1.1"

architecture = "amd64"

