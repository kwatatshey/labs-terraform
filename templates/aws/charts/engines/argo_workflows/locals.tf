locals {
  values_yaml_path = "${path.module}/yamls/values.yaml"
  argo_workflows_values_yaml = templatefile(local.values_yaml_path, {
    sso_enabled              = var.sso_enabled
    argocd_github_sso_secret = var.argocd_github_sso_secret
    hostname                 = var.hostname
    argocd_hostname          = var.argocd_hostname
  })
}