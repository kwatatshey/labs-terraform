resource "helm_release" "keda" {
  namespace        = var.namespace
  name             = var.chart_name
  chart            = var.chart_name
  repository       = var.repository
  version          = var.chart_version
  create_namespace = true
  wait             = true

  values = [
    local.keda_values
  ]

  lifecycle {
    precondition {
      condition     = fileexists(local.values_yaml_path)
      error_message = " --> Error: Failed to find '${local.values_yaml_path}'. Exit terraform process."
    }
  }
}

module "keda_poc" {
  count                     = var.keda_poc_enabled ? 1 : 0
  source                    = "./keda_poc"
  namespace                 = var.namespace
  region                    = var.region
  cluster_oidc_provider_arn = var.cluster_oidc_provider_arn
}

