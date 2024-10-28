resource "helm_release" "argo-events" {
  name             = var.argo_events_chart_name
  chart            = var.argo_events_chart_name
  repository       = var.repository
  version          = var.argo_events_chart_version
  namespace        = var.namespace
  create_namespace = var.create_namespace
  wait             = true
}

resource "helm_release" "argo-workflows" {
  name       = var.argo_workflows_chart_name
  chart      = var.argo_workflows_chart_name
  repository = var.repository
  version    = var.argo_workflows_chart_version
  namespace  = var.namespace
  wait       = true

  values = [
    local.argo_workflows_values_yaml
  ]

  depends_on = [
    helm_release.argo-events
  ]

  lifecycle {
    precondition {
      condition     = fileexists(local.values_yaml_path)
      error_message = " --> Error: Failed to find '${local.values_yaml_path}'. Exit terraform process."
    }
  }
}
