terraform {
  source = "git::git@github.com:kwatatshey/labs-terraform-modules.git//templates/aws/charts/system_charts"
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
    vpc_id                             = "vpc-1234"
    r53_zone_name                      = "zone_id"
    cluster_endpoint                   = "https://example.com/eks"
    cluster_certificate_authority_data = "aGVsbG93b3JsZAo="
    cluster_name                       = "test_cluster"
    acm_certificate_arn                = "aGVsbG93b3JsZAo="
    cluster_oidc_provider_arn          = "arn::test"
    cluster_version                    = "1.30"
  }
}

locals {
  my_region   = include.root.locals.my_region_conf.locals.my_region
  common_tags = include.root.locals.my_env_conf.inputs.common_tags
}

inputs = {
  region                    = local.my_region
  cluster_name              = dependency.eks.outputs.cluster_name
  cluster_version           = dependency.eks.outputs.cluster_version
  cluster_endpoint          = dependency.eks.outputs.cluster_endpoint
  vpc_id                    = dependency.eks.outputs.vpc_id
  domain_name               = dependency.eks.outputs.r53_zone_name
  acm_certificate_arn       = dependency.eks.outputs.acm_certificate_arn
  cluster_oidc_provider_arn = dependency.eks.outputs.cluster_oidc_provider_arn

  # Cluster Autoscaler           
  cluster_autoscaler_enabled   = false
  cluster_autoscaler_namespace = "cluster-autoscaler"

  # Karpenter Autoscaler
  karpenter_enabled   = true
  karpenter_namespace = "kube-system"

  # ALB Contorller           
  alb_controller_enabled   = true # if true then kong must be false
  alb_controller_namespace = "kube-system"

  # Kong
  kong_enabled   = false # if true then alb_controller must be false
  kong_namespace = "kong"

  # External DNS           
  eks_external_dns_enabled = true
  external_dns_namespace   = "external-dns"

  # External S
  external_secrets_enabled   = true
  external_secrets_namespace = "external-secrets"
  external_secrets_regex     = "*" # For ARN

  # EBS CSI Driver
  ebs_csi_enabled          = true
  ebs_csi_driver_namespace = "kube-system"

  # Metrics Server
  metrics_server_enabled   = true
  metrics_server_namespace = "kube-system"

  # Cert Manager
  cert_manager_enabled   = false
  cert_manager_namespace = "cert-manager"

  # Node Trmination Handler
  aws_node_termination_handler_enabled   = true
  aws_node_termination_handler_namespace = "kube-system"

  # Keda
  keda_enabled     = false
  keda_poc_enabled = false
  keda_namespace   = "keda"

  # Cluster Custom Helm Addons(operator)
  enabled_custom_helm = true
  tags                = local.common_tags
}
