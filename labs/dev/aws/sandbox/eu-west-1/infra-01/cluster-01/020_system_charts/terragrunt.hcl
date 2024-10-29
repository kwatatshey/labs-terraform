# terraform {
#   source = "${get_repo_root()}/templates/aws/charts/system_charts"
# }

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
    vpc_id                = "vpc-1234"
    r53_zone_name         = "zone_id"
    eks_endpoint          = "https://example.com/eks"
    eks_certificate       = "aGVsbG93b3JsZAo="
    eks_cluster_name      = "test_cluster"
    acm_certificate_arn   = "aGVsbG93b3JsZAo="
    eks_oidc_provider_arn = "arn::test"
  }
}

locals {
  my_region = include.root.locals.my_region_conf.locals.my_region
}

inputs = {
  region                    = local.my_region
  cluster_name              = dependency.eks.outputs.eks_cluster_name
  cluster_endpoint          = dependency.eks.outputs.eks_endpoint
  vpc_id                    = dependency.eks.outputs.vpc_id
  domain_name               = dependency.eks.outputs.r53_zone_name
  acm_certificate_arn       = dependency.eks.outputs.acm_certificate_arn
  cluster_oidc_provider_arn = dependency.eks.outputs.eks_oidc_provider_arn

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
}
