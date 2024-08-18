resource "helm_release" "jaeger" {
  name             = var.name
  chart            = "jaeger"
  repository       = "https://jaegertracing.github.io/helm-charts"
  version          = var.jaeger_helm_chart_version
  namespace        = var.namespace
  create_namespace = var.namespace != "kube-system"
  values           = [local.values]

  lifecycle {
    precondition {
      condition     = fileexists(local.jaeger_yaml_path)
      error_message = " --> Error: Failed to find '${local.jaeger_yaml_path}'. Exit terraform process."
    }
  }
}
