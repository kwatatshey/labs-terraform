# CLUSTER AUTO-SCALERS
module "cluster-autoscaler" {
  count                     = var.cluster_autoscaler_enabled && !var.karpenter_enabled ? 1 : 0
  source                    = "./cluster_autoscaler"
  enabled                   = var.cluster_autoscaler_enabled
  namespace                 = var.cluster_autoscaler_namespace
  region                    = var.region
  cluster_name              = var.cluster_name
  cluster_oidc_provider_arn = var.cluster_oidc_provider_arn
}

module "karpenter" {
  count                     = var.karpenter_enabled && !var.cluster_autoscaler_enabled ? 1 : 0
  source                    = "./karpenter"
  namespace                 = var.karpenter_namespace
  cluster_name              = var.cluster_name
  cluster_oidc_provider_arn = var.cluster_oidc_provider_arn
  region                    = var.region
  cluster_endpoint          = var.cluster_endpoint
}

# INGRESS CONTROLLERS
module "alb-controller" {
  count                     = var.alb_controller_enabled && !var.kong_enabled ? 1 : 0
  source                    = "./alb_controller"
  namespace                 = var.alb_controller_namespace
  create_role_enabled       = true
  region                    = var.region
  cluster_name              = var.cluster_name
  cluster_oidc_provider_arn = var.cluster_oidc_provider_arn
  vpc_id                    = var.vpc_id
}

module "kong" {
  count     = var.kong_enabled && !var.alb_controller_enabled ? 1 : 0
  source    = "./kong_ingress_controller"
  namespace = var.kong_namespace
}
# IF Both alb_controller_enabled and kong_enabled are set to true, none will be created
# Because of the logical conditions 
# count     = var.kong_enabled && !var.alb_controller_enabled ? 1 : 0
# count                     = var.alb_controller_enabled && !var.kong_enabled ? 1 : 0
# Meaning Only one of them can be enabled at a time or isolte condition as follows:

# module "alb-controller" {
#   count = var.alb_controller_enabled ? 1 : 0
#   ...
# }

# module "kong" {
#   count = var.kong_enabled ? 1 : 0
#   ...
# }


module "aws_node_termination_handler" {
  count        = var.aws_node_termination_handler_enabled ? 1 : 0
  source       = "./aws_node_termination_handler"
  namespace    = var.aws_node_termination_handler_namespace
  cluster_name = var.cluster_name
}

module "metrics_server" {
  count        = var.metrics_server_enabled ? 1 : 0
  source       = "./metrics_server"
  namespace    = var.metrics_server_namespace
  cluster_name = var.cluster_name
}

module "ebs_csi_driver" {
  count                     = var.ebs_csi_enabled ? 1 : 0
  source                    = "./ebs_csi"
  namespace                 = var.ebs_csi_driver_namespace
  region                    = var.region
  cluster_oidc_provider_arn = var.cluster_oidc_provider_arn
}

module "eks_external-dns" {
  count                     = var.eks_external_dns_enabled ? 1 : 0
  source                    = "./eks_external_dns"
  cluster_name              = var.cluster_name
  cluster_oidc_provider_arn = var.cluster_oidc_provider_arn
  domain_name               = var.domain_name
  region                    = var.region
  namespace                 = var.external_dns_namespace
  create_role_enabled       = true
}

module "cert-manager" {
  count        = var.cert_manager_enabled ? 1 : 0
  source       = "./certificate_manager"
  cluster_name = var.cluster_name
  namespace    = var.cert_manager_namespace
}

# SECRETS MANAGER
module "external_secrets" {
  count                     = var.external_secrets_enabled ? 1 : 0
  source                    = "./external_secrets"
  region                    = var.region
  namespace                 = var.external_secrets_namespace
  cluster_oidc_provider_arn = var.cluster_oidc_provider_arn
  secrets_regex             = var.external_secrets_regex
}

# PODS AUTO-SCALERS
module "keda" {
  count                     = var.keda_enabled ? 1 : 0
  source                    = "./keda_operator"
  namespace                 = var.keda_namespace
  cluster_oidc_provider_arn = var.cluster_oidc_provider_arn
  keda_poc_enabled          = var.keda_poc_enabled
  region                    = var.region
}
