module "debian_code_server_vm" {
  source = "../module/debian-vm"

  environmenttype      = var.environmenttype
  new_hostname_prefix  = ""
  new_hostname         = "debian-code-server"
  vm_description       = "Code server for development based on debian"
  vm_tags              = ["tf-ansible"]
  proxmox_node         = var.proxmox_node
  vm_ip_address        = "192.168.80.14/24"
  vm_gateway           = "192.168.80.1"
  vm_bios_type         = "seabios"
  system_start_on_boot = false
  keep_system_running  = true
  clone_vm_id          = 5000
  storage_pool         = var.storage_pool
  vm_dedicated_memory  = 2048
  var_cpu_cores        = 2
  var_cpu_sockets      = 1
  QMEU_machine_type    = "q35"
  disk_size            = 128
  disk_format          = "qcow2"
  interface_bridge     = var.interface_bridge
  vlan_id              = var.interface_vlan_id
}
