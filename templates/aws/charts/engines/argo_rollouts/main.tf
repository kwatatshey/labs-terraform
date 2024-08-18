resource "helm_release" "argo_rollouts" {
  name             = var.chart_name
  chart            = var.chart_name
  repository       = var.repository
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = var.create_namespace

  values           = [
    local.argo_rollouts_values_yaml
  ]

  lifecycle {
    precondition {
      condition     = fileexists(local.values_yaml_path)
      error_message = " --> Error: Failed to find '${local.values_yaml_path}'. Exit terraform process."
    }
  }
}

module "argo_rollouts_demo" {
  count                      = var.customized_demo_enabled || var.traffic_light_demo_enabled ? 1 : 0
  source                     = "./argo_rollouts_demo"
  namespace                  = var.namespace
  release_name               = var.chart_name
  domain_name                = var.domain_name
  traffic_light_demo_enabled = var.traffic_light_demo_enabled

  depends_on = [
    helm_release.argo_rollouts
  ]
}