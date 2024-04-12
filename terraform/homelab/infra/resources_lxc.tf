module "pi_hole_lxc" {
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

# module "gitea_runner_lxc" {
#   source = "../../module/debian-lxc"

#   count = local.yaml_variables_list.gitea_runner_lxc.lxc_details.number_of_instances

#   environmenttype           = local.yaml_variables_list.environmenttype
#   new_hostname              = "${local.yaml_variables_list.gitea_runner_lxc.lxc_details.name}-${format("%02d", count.index + 1)}"
#   lxc_description           = local.yaml_variables_list.gitea_runner_lxc.lxc_details.description
#   proxmox_node              = local.yaml_variables_list.proxmox_node
#   storage_pool              = local.yaml_variables_list.gitea_runner_lxc.lxc_details.storage_pool
#   start_on_boot             = true
#   started                   = true
#   var_cpu_cores             = local.yaml_variables_list.gitea_runner_lxc.lxc_details.cpu_cores
#   var_cpu_architecture      = "amd64"
#   cpu_units                 = 1024
#   new_lxc_os_type           = "debian"
#   os_storage_disk_size      = 32
#   lxc_dedicated_memory      = local.yaml_variables_list.gitea_runner_lxc.lxc_details.memory
#   template_file_location_id = local.yaml_variables_list.template_file_location_id
#   lxc_tags                  = ["lxc", "tf-ansible", "gitea-runner"]

#   ip_details = [
#     {
#       lxc_ip_address = local.yaml_variables_list.gitea_runner_lxc.network_interface_details["first_interface"].ip
#       lxc_gateway    = local.yaml_variables_list.dev_lxc_network_interface_details["first_interface"].gateway
#     }
#   ]

#   list_of_networks = [
#     {
#       name     = "eth0"
#       bridge   = local.yaml_variables_list.gitea_runner_lxc.network_interface_details["first_interface"].interface_bridge
#       enabled  = true
#       firewall = false
#       vlan_id  = local.yaml_variables_list.gitea_runner_lxc.network_interface_details["first_interface"].vlan_id
#     }
#   ]
# }

module "proxy_ingress_lxc" {
  source = "../../module/debian-lxc"

  # create this VM only if its in the array needed_vms
  # count = contains(local.yaml_variables_list.needed_vms, local.yaml_variables_list.pihole_vm_name) ? 1 : 0
  count = local.yaml_variables_list.proxy_ingress_lxc.lxc_details.number_of_instances

  environmenttype           = local.yaml_variables_list.environmenttype
  new_hostname              = "${local.yaml_variables_list.proxy_ingress_lxc.lxc_details.host_name_inside_vm}${format("%02d", count.index + 1)}"
  lxc_description           = local.yaml_variables_list.proxy_ingress_lxc.lxc_details.description
  proxmox_node              = local.yaml_variables_list.proxy_ingress_lxc.host_details.proxmox_node
  storage_pool              = local.yaml_variables_list.proxy_ingress_lxc.lxc_details.storage_pool
  start_on_boot             = true
  started                   = true
  var_cpu_cores             = local.yaml_variables_list.proxy_ingress_lxc.lxc_details.cpu_cores
  var_cpu_architecture      = "amd64"
  cpu_units                 = 1024
  new_lxc_os_type           = "debian"
  os_storage_disk_size      = local.yaml_variables_list.proxy_ingress_lxc.lxc_details.os_storage_disk_size
  lxc_dedicated_memory      = local.yaml_variables_list.proxy_ingress_lxc.lxc_details.memory
  template_file_location_id = local.yaml_variables_list.template_file_location_id
  lxc_tags                  = ["lxc", "npm", "proxy-ingress"]

  ip_details = [
    {
      lxc_ip_address = local.yaml_variables_list.proxy_ingress_lxc.lxc_details.network_interface_details["first_interface"].ip
      lxc_gateway    = local.yaml_variables_list.proxy_ingress_lxc.lxc_details.network_interface_details["first_interface"].gateway
    }
  ]

  list_of_networks = [
    {
      name     = "eth0"
      bridge   = local.yaml_variables_list.proxy_ingress_lxc.lxc_details.network_interface_details["first_interface"].interface_bridge
      enabled  = true
      firewall = false
      vlan_id  = local.yaml_variables_list.proxy_ingress_lxc.lxc_details.network_interface_details["first_interface"].vlan_id
    }
  ]
}
