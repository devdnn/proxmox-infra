variable "environmenttype" {
  type    = string
  default = "dev"  
}

variable proxmox_api_endpoint_url {
  type    = string
  default = "https://192.168.30.22:8006/api2/json"
}

variable proxmox_node {
  type    = string
  default = ""
}

variable proxmox_api_user {
  type    = string
  default = ""
}

variable proxmox_api_password {
  type    = string
  default = ""
}

variable proxmox_tls_insecure {
  type    = bool
  default = true
}

variable "new_hostname_prefix" {
  type    = string
  default = ""
}

variable "new_hostname" {
  type    = string
  default = ""  
}

variable "new_lxc_description" {
  type    = string
  default = "DHCP Server with kea and postgresql"
}

variable "architecture" {
  type    = string
  default = "amd64"  
}

variable "template_file_location_id" {
  type    = string
  default = ""
}

variable "new_lxc_os_type" {
  type    = string
  default = ""  
}

variable "new_lxc_kea_dns_ip_CIDR" {
  type    = string
  default = ""
}

variable "new_lxc_dns_gateway" {
  type    = string
  default = ""  
}

variable "new_lxc_kea_dns_ip_CIDR_temp" {
  type    = string
  default = ""
}

variable "new_lxc_dns_gateway_temp" {
  type    = string
  default = ""  
}

variable "proxmox_storage_pool" {
  type    = string
  default = ""
}


variable "os_storage_disk_size" {
  type    = string
  default = ""
}

variable "postgresql_disk_size" {
  type    = string
  default = ""
}

variable "kea_disk_size" {
  type    = string
  default = ""
}

variable "new_lxc_memory" {
  type    = string
  default = ""
}

variable "new_lxc_swap_memory" {
  type    = string
  default = ""
}

variable "new_lcx_dns_interface_bridge" {
  type    = string
  default = ""
}

variable "new_lcx_dns_interface_bridge_temp" {
  type    = string
  default = ""
}