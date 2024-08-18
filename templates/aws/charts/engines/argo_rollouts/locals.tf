locals {
  values_yaml_path = "${path.module}/yamls/values.yaml"

  argo_rollouts_values_yaml = templatefile(local.values_yaml_path, {
    release_name      = var.chart_name
    domain            = var.domain_name
    dashboard_enabled = var.dashboard_enabled
  })
}