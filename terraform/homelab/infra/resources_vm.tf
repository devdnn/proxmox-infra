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
  snippets_storage_pool   = local.yaml_variables_list.snippets_storage_pool
  vm_dedicated_memory     = 1024
  var_cpu_cores           = 2
  var_cpu_sockets         = 1
  QMEU_machine_type       = "q35"
  list_of_disks = [
    {
      disk_size   = 32
      disk_format = local.yaml_variables_list.supported_disk_format_raw
      interface   = "scsi0"
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
  keep_system_running     = false
  clone_vm_id             = 5000
  storage_pool            = local.yaml_variables_list.nas_storage_pool
  snippets_storage_pool   = local.yaml_variables_list.snippets_storage_pool
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
  snippets_storage_pool   = local.yaml_variables_list.snippets_storage_pool
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

module "docker-coreservices" {
  source = "../../module/debian-vm"

  count = local.yaml_variables_list.docker_core_vm_number_of_instances

  environmenttype         = local.yaml_variables_list.environmenttype
  new_hostname            = "${local.yaml_variables_list.docker_core_vm_name}-${format("%02d", count.index + 1)}"
  new_hostname_inside_vm  = "${replace(local.yaml_variables_list.docker_core_vm_name, "-", "")}${format("%02d", count.index + 1)}"
  vm_description          = local.yaml_variables_list.docker_core_vm_description
  vm_tags                 = ["docker", "core-services", "tf-ansible"]
  proxmox_node            = local.yaml_variables_list.proxmox_node_for_core_services
  proxmox_node_with_clone = local.yaml_variables_list.proxmox_node_with_clone
  vm_bios_type            = "seabios"
  system_start_on_boot    = true
  keep_system_running     = true
  clone_vm_id             = 5000
  storage_pool            = local.yaml_variables_list.storage_pool
  snippets_storage_pool   = local.yaml_variables_list.snippets_storage_pool
  vm_dedicated_memory     = local.yaml_variables_list.docker_core_vm_memory
  var_cpu_cores           = local.yaml_variables_list.docker_core_vm_cpu_cores
  var_cpu_sockets         = 1
  QMEU_machine_type       = "q35"
  list_of_disks = [
    {
      disk_size   = 128
      disk_format = local.yaml_variables_list.docker_core_vm_storage_disk_type
      interface   = "scsi0"
    }
  ]

  list_of_networks = [
    {
      bridge   = local.yaml_variables_list.docker_core_vm_network_interface_details["first_interface"].interface_bridge
      enabled  = true
      firewall = false
      vlan_id  = local.yaml_variables_list.docker_core_vm_network_interface_details["first_interface"].vlan_id
    }
  ]

  ip_details = [
    {
      vm_ip_address = local.yaml_variables_list.docker_core_vm_network_interface_details["first_interface"].ip
      vm_gateway    = local.yaml_variables_list.docker_core_vm_network_interface_details["first_interface"].gateway
    }
  ]
}

module "gitea_runner_vm" {
  source = "../../module/debian-vm"

  count = local.yaml_variables_list.gitea_runner_vm.vm_details.number_of_instances

  environmenttype         = local.yaml_variables_list.environmenttype
  new_hostname            = "${local.yaml_variables_list.gitea_runner_vm.vm_details.name}-${format("%02d", count.index + 1)}"
  new_hostname_inside_vm  = "${replace(local.yaml_variables_list.gitea_runner_vm.vm_details.host_name_inside_vm, "-", "")}${format("%02d", count.index + 1)}"
  vm_description          = local.yaml_variables_list.gitea_runner_vm.vm_details.description
  vm_tags                 = ["docker", "core-services", "tf-ansible"]
  proxmox_node            = local.yaml_variables_list.gitea_runner_vm.host_details.proxmox_node
  proxmox_node_with_clone = local.yaml_variables_list.gitea_runner_vm.host_details.proxmox_node_with_clone
  vm_bios_type            = "seabios"
  system_start_on_boot    = true
  keep_system_running     = true
  clone_vm_id             = local.yaml_variables_list.gitea_runner_vm.host_details.clone_id
  storage_pool            = local.yaml_variables_list.storage_pool
  snippets_storage_pool   = local.yaml_variables_list.snippets_storage_pool
  vm_dedicated_memory     = local.yaml_variables_list.gitea_runner_vm.vm_details.memory
  var_cpu_cores           = local.yaml_variables_list.gitea_runner_vm.vm_details.cpu_cores
  var_cpu_sockets         = 1
  QMEU_machine_type       = "q35"
  list_of_disks = [
    {
      disk_size   = 64
      disk_format = local.yaml_variables_list.gitea_runner_vm.vm_details.os_storage_disk_type
      interface   = "scsi0"
    }
  ]

  list_of_networks = [
    {
      bridge   = local.yaml_variables_list.gitea_runner_vm.vm_details.network_interface_details["first_interface"].interface_bridge
      enabled  = true
      firewall = false
      vlan_id  = local.yaml_variables_list.gitea_runner_vm.vm_details.network_interface_details["first_interface"].vlan_id
    }
  ]

  ip_details = [
    {
      vm_ip_address = local.yaml_variables_list.gitea_runner_vm.vm_details.network_interface_details["first_interface"].ip
      vm_gateway    = local.yaml_variables_list.gitea_runner_vm.vm_details.network_interface_details["first_interface"].gateway
    }
  ]
}

module "dev_debian_vm" {
  source = "../../module/debian-vm"

  count = local.yaml_variables_list.dev_debian_vm.vm_details.number_of_instances

  environmenttype         = local.yaml_variables_list.environmenttype
  new_hostname            = "${local.yaml_variables_list.dev_debian_vm.vm_details.name}-${format("%02d", count.index + 1)}"
  new_hostname_inside_vm  = "${replace(local.yaml_variables_list.dev_debian_vm.vm_details.host_name_inside_vm, "-", "")}${format("%02d", count.index + 1)}"
  vm_description          = local.yaml_variables_list.dev_debian_vm.vm_details.description
  vm_tags                 = ["docker", "core-services", "tf-ansible"]
  proxmox_node            = local.yaml_variables_list.dev_debian_vm.host_details.proxmox_node
  proxmox_node_with_clone = local.yaml_variables_list.dev_debian_vm.host_details.proxmox_node_with_clone
  vm_bios_type            = "seabios"
  system_start_on_boot    = true
  keep_system_running     = true
  clone_vm_id             = local.yaml_variables_list.dev_debian_vm.host_details.clone_id
  storage_pool            = local.yaml_variables_list.storage_pool
  snippets_storage_pool   = local.yaml_variables_list.snippets_storage_pool
  vm_dedicated_memory     = local.yaml_variables_list.dev_debian_vm.vm_details.memory
  var_cpu_cores           = local.yaml_variables_list.dev_debian_vm.vm_details.cpu_cores
  var_cpu_sockets         = 1
  QMEU_machine_type       = "q35"
  list_of_disks = [
    {
      disk_size   = 64
      disk_format = local.yaml_variables_list.dev_debian_vm.vm_details.os_storage_disk_type
      interface   = "scsi0"
    }
  ]

  list_of_networks = [
    {
      bridge   = local.yaml_variables_list.dev_debian_vm.vm_details.network_interface_details["first_interface"].interface_bridge
      enabled  = true
      firewall = false
      vlan_id  = local.yaml_variables_list.dev_debian_vm.vm_details.network_interface_details["first_interface"].vlan_id
    }
  ]

  ip_details = [
    {
      vm_ip_address = local.yaml_variables_list.dev_debian_vm.vm_details.network_interface_details["first_interface"].ip
      vm_gateway    = local.yaml_variables_list.dev_debian_vm.vm_details.network_interface_details["first_interface"].gateway
    }
  ]
}

module "k8s_cp_vm" {
  source = "../../module/debian-vm"

  count = local.yaml_variables_list.k8s_cp_vm.vm_details.number_of_instances

  environmenttype         = local.yaml_variables_list.environmenttype
  new_hostname            = "${local.yaml_variables_list.k8s_cp_vm.vm_details.name}-${format("%02d", count.index + 1)}"
  new_hostname_inside_vm  = "${replace(local.yaml_variables_list.k8s_cp_vm.vm_details.host_name_inside_vm, "-", "")}${format("%02d", count.index + 1)}"
  vm_description          = local.yaml_variables_list.k8s_cp_vm.vm_details.description
  vm_tags                 = ["k8s", "control-plane", "tf-ansible"]
  proxmox_node            = local.yaml_variables_list.k8s_cp_vm.host_details.proxmox_node
  proxmox_node_with_clone = local.yaml_variables_list.k8s_cp_vm.host_details.proxmox_node_with_clone
  vm_bios_type            = "seabios"
  system_start_on_boot    = true
  keep_system_running     = true
  clone_vm_id             = local.yaml_variables_list.k8s_cp_vm.host_details.clone_id
  storage_pool            = local.yaml_variables_list.storage_pool
  snippets_storage_pool   = local.yaml_variables_list.snippets_storage_pool
  vm_dedicated_memory     = local.yaml_variables_list.k8s_cp_vm.vm_details.memory
  var_cpu_cores           = local.yaml_variables_list.k8s_cp_vm.vm_details.cpu_cores
  var_cpu_sockets         = 1
  QMEU_machine_type       = "q35"
  list_of_disks = [
    {
      disk_size   = 64
      disk_format = local.yaml_variables_list.k8s_cp_vm.vm_details.os_storage_disk_type
      interface   = "scsi0"
    }
  ]

  list_of_networks = [
    {
      bridge   = local.yaml_variables_list.k8s_cp_vm.vm_details.network_interface_details["first_interface"].interface_bridge
      enabled  = true
      firewall = false
      vlan_id  = local.yaml_variables_list.k8s_cp_vm.vm_details.network_interface_details["first_interface"].vlan_id
    }
  ]

  ip_details = [
    {
      vm_ip_address = local.yaml_variables_list.k8s_cp_vm.vm_details.network_interface_details["first_interface"].ip
      vm_gateway    = local.yaml_variables_list.k8s_cp_vm.vm_details.network_interface_details["first_interface"].gateway
    }
  ]
}

module "k8s_wn_vm" {
  source = "../../module/debian-vm"

  count = local.yaml_variables_list.k8s_wn_vm.vm_details.number_of_instances

  environmenttype         = local.yaml_variables_list.environmenttype
  new_hostname            = "${local.yaml_variables_list.k8s_wn_vm.vm_details.name}-${format("%02d", count.index + 1)}"
  new_hostname_inside_vm  = "${replace(local.yaml_variables_list.k8s_wn_vm.vm_details.host_name_inside_vm, "-", "")}${format("%02d", count.index + 1)}"
  vm_description          = local.yaml_variables_list.k8s_wn_vm.vm_details.description
  vm_tags                 = ["k8s", "worker-node", "tf-ansible"]
  proxmox_node            = local.yaml_variables_list.k8s_wn_vm.host_details.proxmox_node
  proxmox_node_with_clone = local.yaml_variables_list.k8s_wn_vm.host_details.proxmox_node_with_clone
  vm_bios_type            = "seabios"
  system_start_on_boot    = true
  keep_system_running     = true
  clone_vm_id             = local.yaml_variables_list.k8s_wn_vm.host_details.clone_id
  storage_pool            = local.yaml_variables_list.storage_pool
  snippets_storage_pool   = local.yaml_variables_list.snippets_storage_pool
  vm_dedicated_memory     = local.yaml_variables_list.k8s_wn_vm.vm_details.memory
  var_cpu_cores           = local.yaml_variables_list.k8s_wn_vm.vm_details.cpu_cores
  var_cpu_sockets         = 1
  QMEU_machine_type       = "q35"
  list_of_disks = [
    {
      disk_size   = 64
      disk_format = local.yaml_variables_list.k8s_wn_vm.vm_details.os_storage_disk_type
      interface   = "scsi0"
    }
  ]

  list_of_networks = [
    {
      bridge   = local.yaml_variables_list.k8s_wn_vm.vm_details.network_interface_details["first_interface"].interface_bridge
      enabled  = true
      firewall = false
      vlan_id  = local.yaml_variables_list.k8s_wn_vm.vm_details.network_interface_details["first_interface"].vlan_id
    }
  ]

  ip_details = [
    {
      vm_ip_address = local.yaml_variables_list.k8s_wn_vm.vm_details.network_interface_details["first_interface"].ip
      vm_gateway    = local.yaml_variables_list.k8s_wn_vm.vm_details.network_interface_details["first_interface"].gateway
    }
  ]
}
