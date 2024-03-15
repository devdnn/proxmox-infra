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
  // merge the tags with var.environmenttype
  tags = concat(var.vm_tags, [var.environmenttype])
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "nasbackups"
  node_name    = var.proxmox_node

  source_raw {
    data = <<EOF
      #cloud-config
      #cloud-config
        hostname: ${var.new_hostname_inside_vm}
      EOF

    file_name = "${var.new_hostname_inside_vm}.cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "debian_vm" {

  name        = var.new_hostname
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
    vm_id     = var.clone_vm_id
    full      = true
    node_name = var.proxmox_node_with_clone
    retries   = 3
  }


  initialization {
    dynamic "ip_config" {
      for_each = var.ip_details
      content {
        ipv4 {
          address = ip_config.value.vm_ip_address
          gateway = ip_config.value.vm_gateway
        }
      }
    }

    dns {
      domain = "naiduden.dev"
      servers = [
        "192.168.30.43"
      ]
    }

    datastore_id = var.storage_pool

    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }

  memory {
    dedicated = var.vm_dedicated_memory
  }

  cpu {
    cores   = var.var_cpu_cores
    sockets = var.var_cpu_sockets
    type    = "x86-64-v2-AES"
  }

  dynamic "network_device" {
    for_each = var.list_of_networks
    content {
      bridge   = network_device.value.bridge
      enabled  = network_device.value.enabled
      firewall = network_device.value.firewall
      model    = "virtio"
      vlan_id  = network_device.value.vlan_id
    }
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

  lifecycle {
    ignore_changes = [
      clone, vga
    ]
  }
}
