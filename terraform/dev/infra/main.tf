terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.46.3"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_api_endpoint_url
  username = var.proxmox_api_user
  password = var.proxmox_api_password
  insecure = var.proxmox_tls_insecure
  /* pm_log_enable = true
    pm_log_file   = "terraform-plugin-proxmox.log"
    pm_debug      = true
    pm_log_levels = {
        _default    = "debug"
        _capturelog = ""
    } */
  ssh {
    agent = true
  }
}

module "gitea_vm" {
  source = "../../module/debian-vm"

  environmenttype      = var.environmenttype
  new_hostname_prefix  = "dev"
  new_hostname         = "gitea"
  vm_description       = "Gitea for source control management and CI/CD"
  proxmox_node         = var.proxmox_node
  vm_ip_address        = "192.168.80.13/24"
  vm_gateway           = "192.168.80.1"
  vm_bios_type         = "seabios"
  system_start_on_boot = false
  clone_vm_id          = 5000
  storage_pool         = "proxvz"
  vm_dedicated_memory  = 1024
  var_cpu_cores        = 2
  var_cpu_sockets      = 1
  QMEU_machine_type    = "q35"
  disk_size            = 22
  disk_format          = "qcow2"
  interface_bridge     = "vmbr0"
}


output "vm_details" {
  value = module.gitea_vm.vm_instance_ip_address
}
