# terraform {
#   source = "${get_repo_root()}/templates/aws/charts/engines"
# }

terraform {
  source = "git::git@github.com:kwatatshey/labs-terraform-modules.git//templates/aws/charts/engines"
}

# For Inputs
include "root" {
  path   = find_in_parent_folders()
  expose = true
}

# For AWS provider & tfstate S3 backand
include "cloud" {
  path = find_in_parent_folders("cloud.hcl")
}

# For Helm, Kubectl & GitHub providers
include "common_providers" {
  path = find_in_parent_folders("providers.hcl")
}

dependency "eks" {
  config_path = "../010_eks"
  mock_outputs = {
    vpc_id                = "vpc-1234"
    r53_zone_name         = "zone_name"
    r53_zone_id           = "zone_id"
    eks_endpoint          = "https://example.com/eks"
    eks_certificate       = "aGVsbG93b3JsZAo="
    eks_cluster_name      = "test_cluster"
    acm_certificate_arn   = "aGVsbG93b3JsZAo="
    eks_oidc_provider_arn = "arn::test"
    eks_oidc_issuer_url   = "https://"
  }
}

dependency "system_charts" {
  config_path = "../020_system_charts"
  mock_outputs = {
    cluster_secret_store_ref_name = "global-cluster-secretstore"
  }
}

locals {
  my_region    = include.root.locals.my_region_conf.locals.my_region
  github_org   = include.root.locals.my_org_conf.locals.github_org
  github_repos = include.root.locals.my_org_conf.locals.github_repos
  github_team  = include.root.locals.my_org_conf.locals.github_argocd_admins_team
}

inputs = {
  region                        = local.my_region
  cluster_name                  = dependency.eks.outputs.eks_cluster_name
  vpc_id                        = dependency.eks.outputs.vpc_id
  domain_name                   = dependency.eks.outputs.r53_zone_name
  r53_zone_id                   = dependency.eks.outputs.r53_zone_id
  acm_certificate_arn           = dependency.eks.outputs.acm_certificate_arn
  cluster_oidc_provider_arn     = dependency.eks.outputs.eks_oidc_provider_arn
  eks_oidc_issuer_url           = dependency.eks.outputs.eks_oidc_issuer_url
  cluster_secret_store_ref_name = dependency.system_charts.outputs.cluster_secret_store_ref_name

  # jenkins         
  jenkins_enabled   = true
  jenkins_namespace = "jenkins"

  # apache-airflow
  airflow_enabled   = true
  airflow_namespace = "airflow"

  # argo-workflows         
  argo_workflows_enabled     = true
  argo_workflows_sso_enabled = true # Possible only if ArgoCD SSO enabled as well.
  argo_workflows_namespace   = "argo-workflows"

  # argo-rollouts
  argo_rollouts_enabled                    = true
  argo_rollouts_dashboard_enabled          = true # Recommented to disable it when 'argo_rollouts_extension_enable' for ArgoCD is enabled.
  argo_rollouts_namespace                  = "argo-rollouts"
  argo_rollouts_customized_demo_enabled    = true # Manage your own demo (by CLI/UI). Deploy only initial resources (Rollout + Service + Ingress).
  argo_rollouts_traffic_light_demo_enabled = true # Automatically Runs the Traffic-Light demo. Green(success)->Yellow(success)->Red(fail).

  # argocd
  argocd_enabled   = true
  argocd_namespace = "argocd"

  # --> Argo-Rollouts Extension for ArgoCD.
  argo_rollouts_extension_enable = false # Enable or Disable Argo-Rollouts extension for ArgoCD.

  # --> GitHub SSO for ArgoCD.
  argocd_sso_enabled        = true
  github_org                = local.github_org
  github_argocd_admins_team = local.github_team
  awssm_sso_secret_name     = "argocd-sso" # Secret name within AWS Secrets Manager Where 'clientId' & 'clientSecret' of GitHub application are stored.

  # --> Connect ArgoCD to Slack channel.
  argocd_slack_enabled    = true
  argocd_slack_channel    = "argocd-notification-slack-integration." # Slack channel name.
  awssm_slack_secret_name = "argocd-slack-app-token"                 # Secret name within AWS Secrets Manager Where 'Slack-OAuth-Token' (xoxb-*) of Slack application is stored.
  negative_feedback       = true                                     # [on-sync-failed, on-sync-status-unknown, on-health-degraded]
  possitive_feedback      = true                                     # [on-deployed, on-sync-running]
  slack_poc_enabled       = true                                     # Test your slack channel with ArgoCD notification.

  # --> Connect ECR registry to ArgoCD.
  ecr_reg_enabled = true

  # --> Create & Connect GitOps repository to ArgoCD. 
  gitops_repo_enabled = true
  gitops_repo         = "gitops"

  # --> Connect microservices repositories to ArgoCD.
  github_repositories_enabled = true
  github_repositories         = local.github_repos # List of all Github repositories to connect ArgoCD
}
