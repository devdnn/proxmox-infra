variable "iso_url" {
  type    = string
  default = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.4.0-amd64-netinst.iso"
}

variable "iso_storage_pool" {
  type    = string
}

variable "iso_checksum" {
  type    = string
  default = "sha512:0262488ce2cec6d95a6c9002cfba8b81ac0d1c29fe7993aa5af30f81cecad3eb66558b9d8689a86b57bf12b8cbeab1e11d128a53356b288d48e339bb003dace5"
}

variable "vmid" {
  type = string
  description = "Proxmox Template ID"
}

variable "cpu_type" {
  type    = string
  default = "kvm64"
}

variable "cores" {
  type    = string
  default = "2"
}

variable "disk_format" {
  type    = string
  default = "qcow2"
}

variable "disk_size" {
  type    = string
  default = "16G"
}

variable "storage_pool" {
  type    = string
}

variable "memory" {
  type    = string
  default = "2048"
}

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "network_vlan" {
  type    = string
  default = "30"
}

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