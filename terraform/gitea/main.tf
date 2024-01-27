terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.45.1"
    }
  }
}

provider "proxmox" {
  endpoint = "https://${var.proxmox_host}"
  username = "root@pam"
  password = "Float12345678"
  insecure = true

  ssh {
    agent = true
  }
}

resource "proxmox_virtual_environment_vm" "gitea" {
  name        = "gitea"
  description = "gitea server"
  tags        = ["terraform", "gitea", var.environmenttype]

  node_name = var.proxmox_node

  bios = "seabios"

  clone {
    vm_id = 5000
    full  = true
  }

  memory {
    dedicated = 1024
  }

  cpu {
    cores   = 2
    sockets = 1
  }

  machine = "q35"
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
