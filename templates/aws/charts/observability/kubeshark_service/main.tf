resource "helm_release" "kubeshark" {
  name             = var.name
  chart            = "kubeshark"
  repository       = "https://helm.kubeshark.co/"
  version          = var.kubeshark_helm_chart_version
  namespace        = var.namespace
  create_namespace = var.namespace != "kube-system"
  values           = [local.values]

  lifecycle {
    precondition {
      condition     = fileexists(local.kubeshark_yaml_path)
      error_message = " --> Error: Failed to find '${local.kubeshark_yaml_path}'. Exit terraform process."
    }
  }
}