module "argocd" {
  count = var.argocd_enabled ? 1 : 0
  source = "./argocd"
  name = var.argocd_release_name
  chart_name = var.argocd_chart_name
  chart_version = var.argocd_chart_version
  repository =  "https://argoproj.github.io/argo-helm"
  namespace = var.argocd_namespace
  serviceaccount = var.argocd_serviceaccount
  hostname = trimsuffix(var.argocd_hostname,".") // removes last "." in google cluster domain
  certificate_issuer_name = var.certificate_issuer_name
  configure_sso = var.argocd_configure_sso
  sso_provider = var.argocd_sso_provider
  sso_client_id = var.argocd_sso_client_id
  sso_org = var.argocd_sso_org
  admin_team_name = var.argocd_admin_team_name
  configure_initial_gitops_repo = var.argocd_configure_initial_gitops_repo
  #Main Project
  main_project_name = var.argocd_main_project_name
  #GitOps repo
  initial_gitops_repo_url = var.argocd_initial_gitops_repo_url
  initial_gitops_repo_username = var.argocd_initial_gitops_repo_username
  initial_gitops_repo_password = var.argocd_initial_gitops_repo_password
  create_root_app = var.argocd_create_root_app
  root_app_name = var.argocd_root_app_name
  root_app_target_revision = var.argocd_root_app_target_revision
  root_app_path = var.argocd_root_app_path
  root_app_destination = var.argocd_root_app_destination
  root_app_dir_recurse = var.argocd_root_app_dir_recurse
  root_app_exclude = var.argocd_root_app_exclude
  oauth_enabled = false
  extra_values =  var.argocd_extra_values
}