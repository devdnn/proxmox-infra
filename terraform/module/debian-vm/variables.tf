
variable "environmenttype" {
  type    = string
  default = "dev"
}

variable "new_hostname" {
  type = string
}

variable "new_hostname_inside_vm" {
  type = string
}

variable "vm_description" {
  type = string
}

variable "vm_tags" {
  type        = list(string)
  description = "value for the tags"
  default     = []
}

variable "proxmox_node" {
  type = string
}

variable "proxmox_node_with_clone" {
  type = string
}

variable "vm_bios_type" {
  type    = string
  default = "seabios"
}
variable "system_start_on_boot" {
  type = bool
}

variable "keep_system_running" {
  type = bool
}

variable "clone_vm_id" {
  type    = number
  default = 5000
}

variable "storage_pool" {
  type = string
}

variable "vm_dedicated_memory" {
  type    = number
  default = 1024
}

variable "var_cpu_cores" {
  type    = number
  default = 2
}

variable "var_cpu_sockets" {
  type    = number
  default = 1
}

variable "QMEU_machine_type" {
  type    = string
  default = "q35"
}

variable "list_of_networks" {
  type = list(object({
    bridge   = string
    enabled  = bool
    firewall = bool
    vlan_id  = number
  }))
  description = "List of networks to be created"
}

variable "ip_details" {
  type = list(object({
    vm_ip_address = string
    vm_gateway    = optional(string)
  }))
}

variable "list_of_disks" {
  type = list(object({
    disk_size   = optional(number)
    disk_format = optional(string)
    interface   = string
  }))
  default = [{
    disk_size   = 16
    disk_format = "raw"
    interface   = "scsi0"
  }]
}
