module "jenkins" {
  count                     = var.jenkins_enabled ? 1 : 0
  source                    = "./jenkins_server"
  namespace                 = var.jenkins_namespace
  serviceaccount            = var.jenkins_serviceaccount
  cluster_name              = var.cluster_name
  cluster_oidc_provider_arn = var.cluster_oidc_provider_arn
  domain_name               = var.domain_name
  certificate_arn           = var.acm_certificate_arn
}

module "airflow" {
  count           = var.airflow_enabled ? 1 : 0
  source          = "./apache_airflow"
  namespace       = var.airflow_namespace
  serviceaccount  = var.airflow_serviceaccount
  domain_name     = var.domain_name
  certificate_arn = var.acm_certificate_arn
}

module "argocd" {
  count                          = var.argocd_enabled ? 1 : 0
  source                         = "./argocd"
  region                         = var.region
  release_name                   = var.argocd_release_name
  cluster_name                   = var.cluster_name
  namespace                      = var.argocd_namespace
  hostname                       = local.argocd_hostname
  eks_oidc_issuer_url            = var.eks_oidc_issuer_url
  github_org                     = var.github_org
  github_repositories_enabled    = var.github_repositories_enabled
  github_repositories            = var.github_repositories
  gitops_repo_enabled            = var.gitops_repo_enabled
  gitops_repo                    = var.gitops_repo
  argocd_github_sso_secret       = var.argocd_github_sso_secret
  ecr_reg_enabled                = var.ecr_reg_enabled
  sso_enabled                    = var.argocd_sso_enabled
  github_admins_team             = var.github_argocd_admins_team
  awssm_sso_secret_name          = var.awssm_sso_secret_name
  argocd_slack_enabled           = var.argocd_slack_enabled
  argocd_slack_channel           = var.argocd_slack_channel
  awssm_slack_secret_name        = var.awssm_slack_secret_name
  possitive_feedback             = var.possitive_feedback
  negative_feedback              = var.negative_feedback
  slack_poc_enabled              = var.slack_poc_enabled
  cluster_secret_store_ref_name  = var.cluster_secret_store_ref_name
  argo_workflows_sso_enabled     = var.argo_workflows_enabled && var.argo_workflows_sso_enabled
  argo_workflows_hostname        = local.argo_workflows_hostname
  argo_workflows_namespace       = var.argo_workflows_namespace
  argo_rollouts_extension_enable = var.argo_rollouts_extension_enable
}

module "argo_workflows" {
  count                    = var.argo_workflows_enabled ? 1 : 0
  source                   = "./argo_workflows"
  namespace                = var.argo_workflows_namespace
  sso_enabled              = var.argo_workflows_sso_enabled && var.argocd_sso_enabled && var.argocd_enabled
  argocd_github_sso_secret = var.argocd_github_sso_secret
  hostname                 = local.argo_workflows_hostname
  argocd_hostname          = local.argocd_hostname

  # Only for SSO
  depends_on = [
    module.argocd
  ]
}

module "argo_rollouts" {
  count                      = var.argo_rollouts_enabled ? 1 : 0
  source                     = "./argo_rollouts"
  customized_demo_enabled    = var.argo_rollouts_customized_demo_enabled
  traffic_light_demo_enabled = var.argo_rollouts_traffic_light_demo_enabled
  namespace                  = var.argo_rollouts_namespace
  domain_name                = var.domain_name
  dashboard_enabled          = var.argo_rollouts_dashboard_enabled
}

# AWS Load Balancer Controller  
# module "aws_load_balancer_controller_irsa_role" {
#   source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version                                = "5.44.2"
#   create_role                            = true
#   role_name_prefix                       = "aws-load-balancer-controller"
#   attach_load_balancer_controller_policy = true

#   oidc_providers = {
#     eks = {
#       provider_arn               = var.cluster_oidc_provider_arn # The OIDC ARN for your EKS cluster
#       namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
#     }
#   }
# }
# resource "helm_release" "aws_load_balancer_controller" {
#   name       = "aws-load-balancer-controller"
#   namespace  = "kube-system"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   version    = "1.8.4"

#   values = [
#     <<EOF
#     clusterName: ${var.cluster_name}
#     region: ${var.region}
#     vpcId: ${var.vpc_id}
#     serviceAccount:
#       create: true
#       name: "aws-load-balancer-controller"
#       annotations:
#         eks.amazonaws.com/role-arn: "${module.aws_load_balancer_controller_irsa_role.iam_role_arn}"
#     EOF
#   ]
#   depends_on = [module.aws_load_balancer_controller_irsa_role]
# }


# module "github_runners" {
#   source                        = "./github_runners"
#   enabled                       = var.github_actions_runner_controller_enabled
#   environment                   = var.environment
#   cluster_oidc_provider         = var.cluster_oidc_provider
#   serviceaccount                = var.github_runner_serviceaccount
#   github_token                  = var.github_token
#   token_ssm_parameter           = var.github_token_ssm_parameter
#   runnerGithubURL               = var.github_runner_reg_url
#   webhook_server_enabled        = var.github_webhook_server_enabled
#   webhook_server_host           = var.github_webhook_server_host
#   webhook_server_path           = var.github_webhook_server_path
#   webhook_server_secret_enabled = var.github_webhook_server_secret_enabled
#   depends_on                    = [module.cluster-autoscaler, module.alb-controller]
#   runners_deploy_list           = var.github_runners_deploy_list
# }
