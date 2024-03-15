terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.47.0"
    }
  }
}

locals {
  yaml_variables_list = yamldecode(file("${path.module}/../../../global_vars/${terraform.workspace}.yml"))
}

output "current_workspace" {
  value = terraform.workspace
}

output "current_environment" {
  value = local.yaml_variables_list.environmenttype
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

  # create this VM only if its in the array needed_vms
  # count = contains(local.yaml_variables_list.needed_vms, local.yaml_variables_list.gitea_vm_name) ? 1 : 0
  count = local.yaml_variables_list.gitea_number_of_instances

  environmenttype         = local.yaml_variables_list.environmenttype
  new_hostname            = "${local.yaml_variables_list.gitea_vm_name}-${format("%02d", count.index + 1)}"
  new_hostname_inside_vm  = "${replace(local.yaml_variables_list.gitea_vm_name, "-", "")}${format("%02d", count.index + 1)}"
  vm_description          = local.yaml_variables_list.gitea_vm_description
  vm_tags                 = ["gitea", "source-control", "tf-ansible"]
  proxmox_node            = local.yaml_variables_list.proxmox_node
  proxmox_node_with_clone = local.yaml_variables_list.proxmox_node_with_clone
  vm_bios_type            = "seabios"
  system_start_on_boot    = true
  keep_system_running     = true
  clone_vm_id             = 5000
  storage_pool            = local.yaml_variables_list.storage_pool
  vm_dedicated_memory     = 1024
  var_cpu_cores           = 2
  var_cpu_sockets         = 1
  QMEU_machine_type       = "q35"
  list_of_disks = [
    {
      disk_size   = 16
      disk_format = local.yaml_variables_list.supported_disk_format_raw
      interface   = "scsi0"
    },
    {
      disk_size   = 64
      disk_format = local.yaml_variables_list.supported_disk_format_raw
      interface   = "scsi1"
    }
  ]

  list_of_networks = [
    {
      bridge   = local.yaml_variables_list.gitea_network_interface_details["first_interface"].interface_bridge
      enabled  = true
      firewall = false
      vlan_id  = local.yaml_variables_list.gitea_network_interface_details["first_interface"].vlan_id
    }
  ]

  ip_details = [
    {
      vm_ip_address = local.yaml_variables_list.gitea_network_interface_details["first_interface"].ip
      vm_gateway    = local.yaml_variables_list.gitea_network_interface_details["first_interface"].gateway
    }
  ]
}

module "proxmox_backup_server" {
  source = "../../module/debian-vm"

  # create this VM only if its in the array needed_vms
  # count = contains(local.yaml_variables_list.needed_vms, local.yaml_variables_list.pxbackup_vm_name) ? 1 : 0
  count = local.yaml_variables_list.pxbackup_number_of_instances

  environmenttype         = local.yaml_variables_list.environmenttype
  new_hostname            = "${local.yaml_variables_list.pxbackup_vm_name}-${format("%02d", count.index + 1)}"
  new_hostname_inside_vm  = "${replace(local.yaml_variables_list.pxbackup_vm_name, "-", "")}${format("%02d", count.index + 1)}"
  vm_description          = local.yaml_variables_list.pxbackup_vm_description
  vm_tags                 = ["pxbackup", "tf-ansible"]
  proxmox_node            = local.yaml_variables_list.proxmox_node
  proxmox_node_with_clone = local.yaml_variables_list.proxmox_node_with_clone
  vm_bios_type            = "seabios"
  system_start_on_boot    = true
  keep_system_running     = true
  clone_vm_id             = 5000
  storage_pool            = local.yaml_variables_list.nas_storage_pool
  vm_dedicated_memory     = 4096
  var_cpu_cores           = 2
  var_cpu_sockets         = 1
  QMEU_machine_type       = "q35"
  list_of_disks = [
    {
      disk_size   = 16
      disk_format = local.yaml_variables_list.supported_disk_format_qcow2
      interface   = "scsi0"
    },
    {
      disk_size   = 1024
      disk_format = local.yaml_variables_list.supported_disk_format_qcow2
      interface   = "scsi1"
    }
  ]

  list_of_networks = [
    {
      bridge   = local.yaml_variables_list.pxbackup_network_interface_details["first_interface"].interface_bridge
      enabled  = true
      firewall = false
      vlan_id  = local.yaml_variables_list.pxbackup_network_interface_details["first_interface"].vlan_id
    },
    {
      bridge   = local.yaml_variables_list.pxbackup_network_interface_details["second_interface"].interface_bridge
      enabled  = true
      firewall = false
      vlan_id  = local.yaml_variables_list.pxbackup_network_interface_details["second_interface"].vlan_id
    }
  ]

  ip_details = [
    {
      vm_ip_address = local.yaml_variables_list.pxbackup_network_interface_details["first_interface"].ip
      vm_gateway    = local.yaml_variables_list.pxbackup_network_interface_details["first_interface"].gateway
    },
    {
      vm_ip_address = local.yaml_variables_list.pxbackup_network_interface_details["second_interface"].ip
      vm_gateway    = local.yaml_variables_list.pxbackup_network_interface_details["second_interface"].gateway
    }
  ]
}

module "pi_hole_vm" {
  source = "../../module/debian-lxc"

  # create this VM only if its in the array needed_vms
  # count = contains(local.yaml_variables_list.needed_vms, local.yaml_variables_list.pihole_vm_name) ? 1 : 0
  count = local.yaml_variables_list.pihole_number_of_instances

  environmenttype           = local.yaml_variables_list.environmenttype
  new_hostname              = "${local.yaml_variables_list.pihole_vm_name}-${format("%02d", count.index + 1)}"
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
      lxc_ip_address = local.yaml_variables_list.pihole_network_interface_details["first_interface"].ip
      lxc_gateway    = local.yaml_variables_list.pihole_network_interface_details["first_interface"].gateway
    }
  ]

  list_of_networks = [
    {
      name     = "eth0"
      bridge   = local.yaml_variables_list.pihole_network_interface_details["first_interface"].interface_bridge
      enabled  = true
      firewall = false
      vlan_id  = local.yaml_variables_list.pxbackup_network_interface_details["first_interface"].vlan_id
    }
  ]
}


module "dev_lxc" {
  source = "../../module/debian-lxc"

  count = local.yaml_variables_list.dev_lxc_number_of_instances

  environmenttype           = "dev"
  new_hostname              = "${local.yaml_variables_list.dev_lxc_vm_name}-${format("%02d", count.index + 1)}"
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
      lxc_ip_address = local.yaml_variables_list.dev_lxc_network_interface_details["first_interface"].ip
      lxc_gateway    = local.yaml_variables_list.dev_lxc_network_interface_details["first_interface"].gateway
    }
  ]

  list_of_networks = [
    {
      name     = "eth0"
      bridge   = local.yaml_variables_list.dev_lxc_network_interface_details["first_interface"].interface_bridge
      enabled  = true
      firewall = false
      vlan_id  = local.yaml_variables_list.dev_lxc_network_interface_details["first_interface"].vlan_id
    }
  ]
}

output "name" {
  value = "${replace(local.yaml_variables_list.postgres_vm_name, "-", "")}-${format("%02d", 0 + 1)}"
}

module "postgres_sql_vm" {
  source = "../../module/debian-vm"

  # create this VM only if its in the array needed_vms
  # count = contains(local.yaml_variables_list.needed_vms, local.yaml_variables_list.postgres_vm_name) ? 1 : 0
  count = local.yaml_variables_list.postgres_number_of_instances

  environmenttype         = local.yaml_variables_list.environmenttype
  new_hostname            = "${local.yaml_variables_list.postgres_vm_name}-${format("%02d", count.index + 1)}"
  new_hostname_inside_vm  = "${replace(local.yaml_variables_list.postgres_vm_name, "-", "")}${format("%02d", count.index + 1)}"
  vm_description          = local.yaml_variables_list.postgres_vm_description
  vm_tags                 = ["postgresql", "tf-ansible"]
  proxmox_node            = local.yaml_variables_list.proxmox_node
  proxmox_node_with_clone = local.yaml_variables_list.proxmox_node_with_clone
  vm_bios_type            = "seabios"
  system_start_on_boot    = true
  keep_system_running     = true
  clone_vm_id             = 5000
  storage_pool            = local.yaml_variables_list.storage_pool
  vm_dedicated_memory     = 4096
  var_cpu_cores           = 2
  var_cpu_sockets         = 1
  QMEU_machine_type       = "q35"
  list_of_disks = [
    {
      disk_size   = 128
      disk_format = local.yaml_variables_list.supported_disk_format_raw
      interface   = "scsi0"
    }
  ]

  list_of_networks = [
    {
      bridge   = local.yaml_variables_list.postgres_network_interface_details["first_interface"].interface_bridge
      enabled  = true
      firewall = false
      vlan_id  = local.yaml_variables_list.postgres_network_interface_details["first_interface"].vlan_id
    }
  ]

  ip_details = [
    {
      vm_ip_address = local.yaml_variables_list.postgres_network_interface_details["first_interface"].ip
      vm_gateway    = local.yaml_variables_list.postgres_network_interface_details["first_interface"].gateway
    }
  ]
}
