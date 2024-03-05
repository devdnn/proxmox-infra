terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.47.0"
    }
  }
}

locals {
  yaml_variables_list = yamldecode(file("${path.module}/../../../global_vars/${var.environmenttype}.yml"))
}

provider "proxmox" {
  endpoint = local.yaml_variables_list.proxmox_api_endpoint_url
  username = local.yaml_variables_list.proxmox_api_user
  password = local.yaml_variables_list.proxmox_api_password
  insecure = local.yaml_variables_list.proxmox_tls_insecure
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
  new_hostname_prefix  = local.yaml_variables_list.gitea_vm_prefix
  new_hostname         = local.yaml_variables_list.gitea_vm_name
  vm_description       = local.yaml_variables_list.gitea_vm_description
  vm_tags              = ["gitea", "source-control", "tf-ansible"]
  proxmox_node         = local.yaml_variables_list.proxmox_node
  vm_ip_address        = local.yaml_variables_list.gitea_server_ip
  vm_gateway           = local.yaml_variables_list.gitea_server_gateway
  vm_bios_type         = "seabios"
  system_start_on_boot = true
  keep_system_running  = true
  clone_vm_id          = 5000
  storage_pool         = local.yaml_variables_list.storage_pool
  vm_dedicated_memory  = 1024
  var_cpu_cores        = 2
  var_cpu_sockets      = 1
  QMEU_machine_type    = "q35"
  disk_size            = 22
  disk_format          = "qcow2"
  interface_bridge     = local.yaml_variables_list.interface_bridge
  vlan_id              = 80
}

module "proxmox_backup_server" {
  source = "../../module/debian-vm"

  environmenttype      = var.environmenttype
  new_hostname_prefix  = local.yaml_variables_list.pxbackup_vm_prefix
  new_hostname         = local.yaml_variables_list.pxbackup_vm_name
  vm_description       = local.yaml_variables_list.pxbackup_vm_description
  vm_tags              = ["pxbackup", "source-control", "tf-ansible"]
  proxmox_node         = local.yaml_variables_list.proxmox_node
  vm_ip_address        = local.yaml_variables_list.pxbackup_server_ip
  vm_gateway           = local.yaml_variables_list.pxbackup_server_gateway
  vm_bios_type         = "seabios"
  system_start_on_boot = true
  keep_system_running  = true
  clone_vm_id          = 5000
  storage_pool         = local.yaml_variables_list.storage_pool
  vm_dedicated_memory  = 2048
  var_cpu_cores        = 2
  var_cpu_sockets      = 1
  QMEU_machine_type    = "q35"
  disk_size            = 22
  disk_format          = "qcow2"
  interface_bridge     = local.yaml_variables_list.interface_bridge
  vlan_id              = 80
}

module "pi_hole_vm" {
  source = "../../module/debian-lxc"

  environmenttype           = var.environmenttype
  new_hostname_prefix       = local.yaml_variables_list.pihole_vm_prefix
  new_hostname              = local.yaml_variables_list.pihole_vm_name
  lxc_description           = local.yaml_variables_list.pihole_vm_description
  proxmox_node              = local.yaml_variables_list.proxmox_node
  storage_pool              = local.yaml_variables_list.storage_pool
  start_on_boot             = true
  started                   = true
  var_cpu_cores             = 1
  var_cpu_architecture      = "amd64"
  cpu_units                 = 1024
  new_lxc_os_type           = "debian"
  os_storage_disk_size      = 8
  lxc_dedicated_memory      = 512
  template_file_location_id = local.yaml_variables_list.template_file_location_id
  lxc_tags                  = ["lxc", "pihole"]
  ip_details = [
    {
      lxc_ip_address = local.yaml_variables_list.pihole_server_ip
      lxc_gateway    = local.yaml_variables_list.pihole_server_gateway
    }
  ]
  list_of_networks = [
    {
      name     = "eth0"
      bridge   = local.yaml_variables_list.interface_bridge
      enabled  = true
      firewall = false
      vlan_id  = 80
    }
  ]


}


module "dev_lxc" {
  source = "../../module/debian-lxc"

  environmenttype           = "dev"
  new_hostname_prefix       = ""
  new_hostname              = "debian-code-server"
  lxc_description           = "LXC for development"
  proxmox_node              = local.yaml_variables_list.proxmox_node
  storage_pool              = local.yaml_variables_list.storage_pool
  start_on_boot             = true
  started                   = true
  var_cpu_cores             = 2
  var_cpu_architecture      = "amd64"
  cpu_units                 = 1024
  new_lxc_os_type           = "debian"
  os_storage_disk_size      = 20
  lxc_dedicated_memory      = 1024
  template_file_location_id = local.yaml_variables_list.template_file_location_id
  lxc_tags                  = ["lxc", "tf-ansible"]
  ip_details = [
    {
      lxc_ip_address = local.yaml_variables_list.dev_lxc_server_ip
      lxc_gateway    = local.yaml_variables_list.dev_lxc_server_gateway
    }
  ]
  list_of_networks = [
    {
      name     = "eth0"
      bridge   = local.yaml_variables_list.interface_bridge
      enabled  = true
      firewall = false
      vlan_id  = 80
    }
  ]
}
