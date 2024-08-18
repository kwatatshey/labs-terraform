locals {
  base_values = templatefile("${path.module}/values.yaml", {
    sa_name                 = var.serviceaccount
    certificate_issuer_name = var.certificate_issuer_name
    release_name            = var.name
    hostname                = var.hostname
    gitops_repo_url         = var.initial_gitops_repo_url
    gitops_repo_username    = var.initial_gitops_repo_username
    gitops_repo_password    = var.initial_gitops_repo_password
    sso_enabled             = var.configure_sso
    sso_provider            = var.sso_provider
    sso_client_id           = var.sso_client_id
    sso_org                 = var.sso_org
    admin_team_name         = var.admin_team_name
    oauth_enabled           = length(var.oauth_client_secret_name) > 0 ? true : false
  })
}
