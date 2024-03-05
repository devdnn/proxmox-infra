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
  hostname = var.new_hostname_prefix == "" ? var.new_hostname : "${var.new_hostname_prefix}-${var.new_hostname}"
  tags     = concat(var.lxc_tags, [var.environmenttype])
}

output "hostname" {
  value = local.hostname
}

resource "proxmox_virtual_environment_container" "debian_lxc" {
  node_name    = var.proxmox_node
  description  = var.lxc_description
  unprivileged = true


  started       = var.started
  start_on_boot = var.start_on_boot
  tags          = local.tags

  cpu {
    cores        = var.var_cpu_cores
    architecture = var.var_cpu_architecture
    units        = var.cpu_units
  }

  operating_system {
    template_file_id = var.template_file_location_id
    type             = var.new_lxc_os_type
  }

  initialization {
    hostname = local.hostname

    dynamic "ip_config" {
      for_each = var.ip_details
      content {
        ipv4 {
          address = ip_config.value.lxc_ip_address
          gateway = ip_config.value.lxc_gateway
        }
      }
    }

    dns {
      domain = "naiduden.dev"
      servers = [
        "192.168.30.43"
      ]
    }

    user_account {
      password = "Float12345678"
    }
  }

  disk {
    datastore_id = var.storage_pool
    size         = var.os_storage_disk_size
  }

  memory {
    dedicated = var.lxc_dedicated_memory
    swap      = var.new_swap_memory
  }


  dynamic "network_interface" {
    for_each = var.list_of_networks
    content {
      name     = network_interface.value.name
      bridge   = network_interface.value.bridge
      enabled  = network_interface.value.enabled
      firewall = network_interface.value.firewall
      vlan_id  = network_interface.value.vlan_id
    }
  }

  lifecycle {
    ignore_changes = [
      network_interface,
      tags,
      started,
      start_on_boot,
    ]
  }
}
