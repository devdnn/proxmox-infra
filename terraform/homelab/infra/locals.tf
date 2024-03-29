locals {
  yaml_variables_list = yamldecode(file("${path.module}/../../../global_vars/${terraform.workspace}.yml"))
}
