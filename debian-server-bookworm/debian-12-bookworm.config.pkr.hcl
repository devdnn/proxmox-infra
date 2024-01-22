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