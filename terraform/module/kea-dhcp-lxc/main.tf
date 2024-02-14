terraform{
    required_providers{
        proxmox = {
            source = "bpg/proxmox"
            version = "0.46.3"
        }
    }
}

provider "proxmox" {
    endpoint = "${var.proxmox_api_endpoint_url}"
    username = "${var.proxmox_api_user}"
    password = "${var.proxmox_api_password}"
    insecure = var.proxmox_tls_insecure
    /* pm_log_enable = true
    pm_log_file   = "terraform-plugin-proxmox.log"
    pm_debug      = true
    pm_log_levels = {
        _default    = "debug"
        _capturelog = ""
    } */
}

locals {
    // timestamp with hour and minute
    timestamp = formatdate("YYYY-MM-DD-HH-mm", timestamp())
    hostname = var.new_hostname_prefix == "" ? var.new_hostname : "${var.new_hostname_prefix}-${var.new_hostname}"
}

resource "proxmox_virtual_environment_container" "dev-kea-dhcp" {
    node_name = "${var.proxmox_node}"
    description  = "${var.new_lxc_description} - ${local.timestamp}"
    unprivileged = true
    

    started = false
    start_on_boot = true
    tags = ["ops", "kea", "postgresql", var.environmenttype]

    cpu {
        cores = 2
        architecture = var.architecture
    }

    operating_system {
        template_file_id = var.template_file_location_id
        type = var.new_lxc_os_type
    }

    initialization {
        hostname = local.hostname

        ip_config {
            ipv4 {
                address = var.new_lxc_kea_dns_ip_CIDR
                gateway = var.new_lxc_dns_gateway
            }
        }

        ip_config {
            ipv4 {
                address = var.new_lxc_kea_dns_ip_CIDR_temp
                gateway = var.new_lxc_dns_gateway_temp
            }
        }

        user_account {
            password = "Float12345678"
        }
    }

    disk {
        datastore_id = var.proxmox_storage_pool
        size    = var.os_storage_disk_size
    }

    memory {
        dedicated = var.new_lxc_memory
        swap      = var.new_lxc_swap_memory
    }

    network_interface {
        name = "eth0"
        bridge = var.new_lcx_dns_interface_bridge
        enabled = true
        firewall = false
        vlan_id = 30
    }

    network_interface {
        name = "eth1"
        bridge = var.new_lcx_dns_interface_bridge_temp
        enabled = true
        firewall = false
    }

    mount_point {
        volume = var.proxmox_storage_pool
        backup = true
        size = var.postgresql_disk_size
        path = "/var/lib/postgresql"
    }

    mount_point {
        volume = var.proxmox_storage_pool
        backup = true
        size = var.kea_disk_size
        path = "/var/lib/kea"
    }
}