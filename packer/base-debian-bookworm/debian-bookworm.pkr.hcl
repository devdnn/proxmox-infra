packer {
  required_plugins {
        proxmox = {
            version = "~> 1"
            source  = "github.com/hashicorp/proxmox"
        }

        ansible = {
            version = "~> 1"
            source  = "github.com/hashicorp/ansible"
        }

        qemu = {
            version = "~> 1"
            source  = "github.com/hashicorp/qemu"
        }

        comment = {
            version = ">=v0.2.23"
            source = "github.com/sylviamoss/comment"
        }
    }
}

source "proxmox-iso" "debian-12" {
  proxmox_url              = "https://${var.proxmox_host}/api2/json"
  username                 = var.proxmox_api_token_id
  token                    = var.proxmox_api_token_secret
  insecure_skip_tls_verify = true
  node                     = var.proxmox_node[0]

  vm_name                 = var.vm_name
  template_description    = "Debian 12 Bookworm Packer Template -- Created: ${formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())}"
  vm_id                   = var.vmid
  
  os                      = "l26"
  cpu_type                = var.cpu_type
  sockets                 = "1"
  cores                   = var.cores
  memory                  = var.memory
  machine                 = "q35"
  bios                    = "seabios"
  scsi_controller         = "virtio-scsi-single"
  
  qemu_agent              = true
  cloud_init              = true
  cloud_init_storage_pool = var.storage_pool

  network_adapters {
    bridge   = var.network_bridge
    firewall = true
    model    = "virtio"
    vlan_tag = var.network_vlan
  }

  disks {
    disk_size         = var.disk_size
    format            = var.disk_format
    storage_pool      = var.storage_pool
    type              = "scsi"
    discard           = true
    ssd               = true
    io_thread         = true
  }

  iso_url          = var.iso_url
  iso_storage_pool = var.iso_storage_pool
  iso_checksum     = var.iso_checksum
  unmount_iso      = true

  #http_directory = "http"
  #http_port_min  = 8100
  #http_port_max  = 8100
  boot_wait      = "10s"
  boot_command   = ["<esc><wait>auto url=https://{{ .HTTPIP }}${var.preseed_url_path}<enter>"]

  #http_directory = "preseed"
  http_bind_address = var.preseed_url_bind_address
  http_port_min = 443
  http_port_max = 443

  ssh_username = "dnndev"
  ssh_password  = "Float12345678"
  ssh_timeout  = "20m"
}


build {
  sources = ["source.proxmox-iso.debian-12"]

  provisioner "shell" {
    inline = [
      "systemctl is-active --quiet dbus && echo 'DBus is active' || echo 'DBus is not active'"
    ]
  }

  # Copy default cloud-init config
  provisioner "file" {
    destination = "/tmp/cloud.cfg"
    source      = "http/cloud.cfg"
  }

  provisioner "shell" {
    inline = ["sudo mv /tmp/cloud.cfg /etc/cloud/cloud.cfg"]
  }

  provisioner "shell" {
    inline = [
        "sudo apt-get -y autoremove --purge",
        "sudo apt-get -y clean",
        "sudo apt-get -y autoclean",
        "sudo cloud-init clean",
        "sudo cloud-init clean"]
  }

  # Copy Proxmox cloud-init config
  provisioner "file" {
    destination = "/tmp/99-pve.cfg"
    source      = "http/99-pve.cfg"
  }

  provisioner "shell" {
    inline = ["sudo mv /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg"]
  }  
}