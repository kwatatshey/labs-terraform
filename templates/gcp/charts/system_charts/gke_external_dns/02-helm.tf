resource "helm_release" "external_dns" {
  name             = var.name
  chart            = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  create_namespace = var.namespace == "kube-system" ? false : true
  version          = var.external_dns_version
  namespace        = var.namespace
  values           = [local.base_values]

  dynamic "set" {
    for_each = var.extra_values
    content {
      name  = set.key
      value = set.value
    }
  }
}