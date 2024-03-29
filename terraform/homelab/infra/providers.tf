terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.47.0"
    }
  }
}

provider "proxmox" {
  endpoint = local.yaml_variables_list.proxmox_api_endpoint_url
  username = local.yaml_variables_list.proxmox_api_user
  password = local.yaml_variables_list.proxmox_api_password
  insecure = local.yaml_variables_list.proxmox_tls_insecure
  /* pm_log_enable = true
    pm_log_file   = "terraform-plugin-proxmox.log"
    pm_debug      = true
    pm_log_levels = {
        _default    = "debug"
        _capturelog = ""
    } */
  ssh {
    agent = true
  }
}
