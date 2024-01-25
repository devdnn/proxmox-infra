build {
  sources = ["source.proxmox-iso.debian-12"]

  # Using ansible playbooks to configure debian
  provisioner "ansible" {
    playbook_file    = "./ansible/debian_config.yml"
    use_proxy        = false
    user             = "dnndev"
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    extra_arguments  = [
      "--extra-vars","ansible_user=dnndev",
      "--extra-vars", "ansible_ssh_pass=Float12345678"]
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