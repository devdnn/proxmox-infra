provider "proxmox" {
  endpoint = var.proxmox_api_endpoint_url
  username = var.proxmox_api_user
  password = var.proxmox_api_password
  insecure = var.proxmox_tls_insecure
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
