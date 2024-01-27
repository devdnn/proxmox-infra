variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
  default   = ""
}

variable "proxmox_api_token_id" {
  type    = string
  default = ""
}

variable "proxmox_host" {
  type    = string
  default = ""
}

variable "proxmox_node" {
  type    = string
  default = ""
}

variable "disk_size" {
  type    = string
  default = "64"
}

variable "disk_format" {
  type    = string
  default = "raw"
}

variable "storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "network_vlan" {
  type    = number
  default = 0
}

variable "environmenttype" {
  type    = string
  default = "dev"  
}