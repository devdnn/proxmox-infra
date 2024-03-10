terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.47.0"
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
  started = var.keep_system_running

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

    dns {
      domain = "naiduden.dev"
      servers = [
        "192.168.30.43"
      ]
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

  dynamic "disk" {
    for_each = var.list_of_disks
    content {
      size         = disk.value.disk_size
      file_format  = disk.value.disk_format
      datastore_id = var.storage_pool
      interface    = disk.value.interface
      iothread     = true
      discard      = "on"
      ssd          = true
    }
  }

  timeout_clone       = 3600
  timeout_create      = 3600
  timeout_move_disk   = 3600
  timeout_migrate     = 3600
  timeout_reboot      = 3600
  timeout_shutdown_vm = 3600
  timeout_start_vm    = 3600
  timeout_stop_vm     = 3600
}
