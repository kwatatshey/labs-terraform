locals {
  values_yaml_path = "${path.module}/yamls/values.yaml"
  keda_values = templatefile(local.values_yaml_path, {
    keda_poc_enabled       = var.keda_poc_enabled
    keda_operator_role_arn = var.keda_poc_enabled ? module.keda_poc[0].keda_irsa_role_arn : ""
  })
}