module "ops_kea_dhcp_lxc" {
  source = "../../module/kea_dhcp_lxc"  

  environmenttype = var.environmenttype
  # host node proxmox details
  proxmox_api_endpoint_url = var.proxmox_api_endpoint_url
  proxmox_node = var.proxmox_node
  proxmox_api_user = var.proxmox_api_user
  proxmox_api_password = var.proxmox_api_password
  proxmox_tls_insecure = var.proxmox_tls_insecure
  # storage settings
  template_file_location_id = var.template_file_location_id
  proxmox_storage_pool = var.proxmox_storage_pool
  os_storage_disk_size = var.os_storage_disk_size
  postgresql_disk_size = var.postgresql_disk_size
  kea_disk_size = var.kea_disk_size
  # memory settings
  new_lxc_memory = var.new_lxc_memory
  new_lxc_swap_memory = var.new_lxc_swap_memory
  # new host details
  new_hostname_prefix = var.new_hostname_prefix
  new_hostname = var.new_hostname
  new_lxc_description = var.new_lxc_description
  new_lxc_os_type = var.new_lxc_os_type
  # network settings
  new_lcx_dns_interface_bridge = var.new_lcx_dns_interface_bridge
  new_lcx_dns_interface_bridge_temp = var.new_lcx_dns_interface_bridge_temp
  new_lxc_kea_dns_ip_CIDR = var.new_lxc_kea_dns_ip_CIDR
  new_lxc_dns_gateway = var.new_lxc_dns_gateway
  new_lxc_kea_dns_ip_CIDR_temp = var.new_lxc_kea_dns_ip_CIDR_temp
  new_lxc_dns_gateway_temp = var.new_lxc_dns_gateway_temp
  architecture = var.architecture 
}