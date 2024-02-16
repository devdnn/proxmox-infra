terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.46.3"
    }
  }
}

locals {
  // timestamp with hour and minute
  timestamp = formatdate("YYYY-MM-DD-HH-mm", timestamp())
  hostname  = var.new_hostname_prefix == "" ? var.new_hostname : "${var.new_hostname_prefix}-${var.new_hostname}"
  // merge the tags with var.environmenttype
  tags = concat(var.vm_tags, [var.environmenttype])
}

resource "proxmox_virtual_environment_vm" "debian_vm" {
  name        = local.hostname
  description = var.vm_description
  tags        = local.tags

  node_name = var.proxmox_node

  bios = var.vm_bios_type
  agent {
    enabled = true
  }
  on_boot = var.system_start_on_boot
  started = false

  clone {
    vm_id = var.clone_vm_id
    full  = true
  }


  initialization {
    ip_config {
      ipv4 {
        address = var.vm_ip_address
        gateway = var.vm_gateway
      }
    }

    datastore_id = var.storage_pool
  }

  memory {
    dedicated = var.vm_dedicated_memory
  }

  cpu {
    cores   = var.var_cpu_cores
    sockets = var.var_cpu_sockets
    type    = "x86-64-v2-AES"
  }

  network_device {
    bridge   = var.interface_bridge
    enabled  = true
    firewall = false
    model    = "virtio"
    vlan_id  = var.vlan_id
  }

  machine = var.QMEU_machine_type
  operating_system {
    type = "l26"
  }

  reboot        = "true"
  scsi_hardware = "virtio-scsi-single"

  disk {
    size         = var.disk_size
    file_format  = var.disk_format
    datastore_id = var.storage_pool
    iothread     = true
    interface    = "scsi0"
    discard      = "on"
    ssd          = true
  }
}
