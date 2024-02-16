
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

variable "vm_bios_type" {
  type    = string
  default = "seabios"
}
variable "system_start_on_boot" {
  type = bool
}

variable "clone_vm_id" {
  type    = number
  default = 5000
}

variable "vm_ip_address" {
  type = string
}

variable "vm_gateway" {
  type = string
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

variable "disk_size" {
  type    = number
  default = 16
}

variable "disk_format" {
  type    = string
  default = "raw"
}

variable "interface_bridge" {
  type    = string
  default = "vmbr0"
}

variable "vlan_id" {
  type = number
}
