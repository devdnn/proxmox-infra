output "current_workspace" {
  value = terraform.workspace
}

output "current_environment" {
  value = local.yaml_variables_list.environmenttype
}


output "name" {
  value = "${replace(local.yaml_variables_list.postgres_vm_name, "-", "")}-${format("%02d", 0 + 1)}"
}
