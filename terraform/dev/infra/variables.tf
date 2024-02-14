variable "environmenttype" {
  type = string
}

variable "proxmox_api_endpoint_url" {
  type = string
}

variable "proxmox_node" {
  type = string
}

variable "proxmox_api_user" {
  type = string
}

variable "proxmox_api_password" {
  type = string
}

variable "proxmox_tls_insecure" {
  type    = bool
  default = true
}
