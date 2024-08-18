resource "helm_release" "kong" {
  name             = var.name
  chart            = "kong"
  repository       = "https://charts.konghq.com"
  create_namespace = var.namespace == "kube-system" ? false : true
  version          = var.kong_chart_version
  namespace        = var.namespace
  # values           = [local.base_values] - No custom values at this point

  dynamic "set" {
    for_each = var.extra_values
    content {
      name  = set.key
      value = set.value
    }
  }
}