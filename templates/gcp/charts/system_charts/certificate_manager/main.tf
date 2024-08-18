# Helm Cert Manager
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  chart            = "cert-manager"
  repository       = "https://charts.jetstack.io"
  version          = var.cert_manager_helm_chart_version
  namespace        = var.namespace
  create_namespace = true

  set {
    name  = "installCRDs"
    value = true
  }
  set {
    name  = "serviceAccount.create"
    value = true
  }
  set {
    name  = "serviceAccount.name"
    value = "cert-manager"
  }
  set {
    name  = "prometheus.enabled"
    value = false
  }
  set {
    name  = "webhook.mutatingWebhookConfigurationAnnotations.cert-manager\\.io/inject-ca-from"
    value = "cert-manager/dummy-certificate"
  }
}


# ## Cert Manager Cluster Issuer - Staging issuer - NOT FOR PRODUCTION
# resource "kubernetes_manifest" "letsencrypt_cluster_issuer_staging" {
#   count = var.cert_manager_issuer_staging_mode == true ? 1 : 0 
#   manifest = yamldecode(<<-EOT
#     apiVersion: cert-manager.io/v1
#     kind: ClusterIssuer
#     metadata:
#       name: letsencrypt-staging
#     spec:
#       acme:
#         email: ${var.issuer_email}
#         server: https://acme-staging-v02.api.letsencrypt.org/directory
#         privateKeySecretRef:
#           # Secret resource that will be used to store the account's private key.
#           name: "${var.cluster_name}-letsencrypt-key"
#         solvers:
#         - http01:
#             ingress:
#               class: ${var.ingress_class_name}    
#     EOT
#     )
# }
# resource "kubernetes_manifest" "letsencrypt_cluster_issuer_prod" {
#   count = var.cert_manager_issuer_production_mode == true ? 1 : 0 
#   manifest = yamldecode(<<-EOT
#     apiVersion: cert-manager.io/v1
#     kind: ClusterIssuer
#     metadata:
#       name: letsencrypt-prod
#     spec:
#       acme:
#         email: ${var.issuer_email}
#         server: https://acme-v02.api.letsencrypt.org/directory
#         privateKeySecretRef:
#           # Secret resource that will be used to store the account's private key.
#           name: "${var.cluster_name}-letsencrypt-priv-key"
#         solvers:
#         - http01:
#             ingress:
#               class: ${var.ingress_class_name}
#     EOT
#     )
# }