variable "environmenttype" {
  type    = string
  default = "dev"
}

variable "new_hostname_prefix" {
  type    = string
  default = ""
}

variable "new_hostname" {
  type = string
}

variable "lxc_description" {
  type = string
}

variable "lxc_tags" {
  type        = list(string)
  description = "value for the tags"
  default     = []
}

variable "proxmox_node" {
  type = string
}

variable "var_cpu_cores" {
  type    = number
  default = 2
}

variable "var_cpu_architecture" {
  type    = string
  default = "amd64"
}

variable "cpu_units" {
  type    = number
  default = 1024
}

variable "template_file_location_id" {
  type = string
}

variable "new_lxc_os_type" {
  type    = string
  default = "debian"
}

variable "storage_pool" {
  type = string
}

variable "os_storage_disk_size" {
  type    = number
  default = 8
}

variable "lxc_dedicated_memory" {
  type    = number
  default = 1024
}

variable "new_swap_memory" {
  type    = number
  default = 1024
}

variable "started" {
  type        = bool
  description = "Start lxc on creation"
  default     = true
}

variable "start_on_boot" {
  type        = bool
  description = "Start lxc on boot"
  default     = true
}

variable "ip_details" {
  type = list(object({
    lxc_ip_address = string
    lxc_gateway    = optional(string)
  }))
}

variable "list_of_networks" {
  type = list(object({
    name     = string
    bridge   = string
    enabled  = bool
    firewall = bool
    vlan_id  = number
  }))
  description = "List of networks to be created"
}
