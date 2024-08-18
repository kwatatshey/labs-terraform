resource "helm_release" "argocd" {
  namespace        = var.namespace
  create_namespace = var.create_namespace
  name             = var.chart_name
  chart            = var.chart_name
  repository       = var.repository
  version          = var.chart_version
  recreate_pods    = var.recreate_pods
  timeout          = var.timeout
  values           = [local.base_values]

  dynamic "set" {
    for_each = var.extra_values
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "kubectl_manifest" "main_project" {
  depends_on = [ helm_release.argocd ]
  # apply_only = true
  yaml_body = <<YAML
  apiVersion: argoproj.io/v1alpha1
  kind: AppProject
  metadata:
    name: ${var.main_project_name}
    namespace: ${var.namespace}
    labels:
      app.kubernetes.io/managed-by: Helm
  spec:
    sourceRepos:
      - ${var.initial_gitops_repo_url}
    destinations:
      - server:  ${var.root_app_destination}
        namespace: '*'
    # clusterResourceWhitelist:   # This section defines the allowed resources on cluster level!!
    #   - group: '*'               # Core group (no group)
    #     kind: '*'        # Kind of the resource
  YAML
}

resource "kubectl_manifest" "argocd_root_app" {
  count = var.create_root_app == true ? 1 : 0 
  depends_on = [ helm_release.argocd, kubectl_manifest.main_project ]
  apply_only = true
  yaml_body = <<YAML
  apiVersion: argoproj.io/v1alpha1
  kind: Application
  metadata:
    name: ${var.root_app_name}
    namespace: ${var.namespace}
    labels:
      app.kubernetes.io/managed-by: Helm
  spec:
    project: ${var.main_project_name}
    source:
      repoURL: ${var.initial_gitops_repo_url}
      targetRevision: ${var.root_app_target_revision}
      path: ${var.root_app_path}
      directory:
        recurse: ${var.root_app_dir_recurse}
        exclude: ${var.root_app_exclude}
    destination:
      server: ${var.root_app_destination}
  YAML
} 


# set {
#     name  = "server.config.statusbadge\\.enabled"
#     value = "true"
#     type  = "string"
#   }

#   #TODO: Enable  metics.

#   ## Notificattions:
#   set {
#     name  = "notifications.argocdUrl"
#     value = "https://${var.argo_cd.host}"
#   }

#   set {
#     name  = "notifications.secret.create"
#     value = "false"
#   }

#   set {
#     name  = "notifications.secret.name"
#     value = "argocd-notifications-secret"
#   }

#   set {
#     name  = "notifications.cm.create"
#     value = "false"
#   }

#   set {
#     name  = "notifications.cm.name"
#     value = "argocd-notifications-cm"
#   }

#   # Disable applicationsets:
#   # https://github.com/argoproj/argo-helm/issues/1180
#   set {
#     name  = "applicationSet.enabled"
#     value = "false"
#   }

#   depends_on = [
#     kubectl_manifest.argocd_notifications_secret,
#     kubectl_manifest.argocd_notifications_cm,
#     time_sleep.wait # wait until ingress is ready
#   ]

# }

# resource "kubectl_manifest" "argocd_notifications_secret" {
#   count              = var.argo_cd.enabled ? 1 : 0
#   override_namespace = var.argo_cd.namespace
#   yaml_body = templatefile("${path.module}/templates/argocd-notifications-secret.yaml.tpl", {
#     slack_token = var.slack_token
#   })

# }

# # notifications https://github.com/argoproj/argo-cd/blob/master/notifications_catalog/install.yaml
# resource "kubectl_manifest" "argocd_notifications_cm" {
#   count              = var.argo_cd.enabled ? 1 : 0
#   override_namespace = var.argo_cd.namespace
#   yaml_body = templatefile("${path.module}/templates/argocd-notifications-cm.yaml.tpl", {
#     host        = var.argo_cd.host,
#     environment = var.environment
#   })
#   depends_on = [
#     kubectl_manifest.argocd_notifications_secret,
#   ]
# }