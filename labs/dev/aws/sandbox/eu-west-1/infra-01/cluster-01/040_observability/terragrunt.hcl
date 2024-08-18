terraform {
  source = "${get_repo_root()}/templates/aws/charts/observability"
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
  config_path  = "../010_eks"
  mock_outputs = {
    vpc_id              = "vpc-1234"
    r53_zone_name       = "zone_id"
    eks_endpoint        = "https://example.com/eks"
    eks_certificate     = "aGVsbG93b3JsZAo="
    eks_cluster_name    = "test_cluster"
    eks_region          = "us-east-1"
    acm_certificate_arn = "aGVsbG93b3JsZAo="
    eks_oidc_provider_arn = "arn::test"
    cluster_autoscaler  = {
      enabled        = true
      namespace      = "dummy"
      serviceaccount = "sa"
      role_arn       = "arn::test"
    }
    alb_controller = {
      enabled        = true
      namespace      = "dummy"
      serviceaccount = "sa"
      role_arn       = "arn::test"
    }
    airflow = {
      enabled        = "true"
      namespace      = "dummy"
      serviceaccount = "sa"
    }
    external_dns = {
      enabled        = true
      namespace      = "dummy"
      serviceaccount = "sa"
      role_arn       = "arn::test"
    }
    external_secrets = {
      enabled        = true
      namespace      = "dummy"
      serviceaccount = "sa"
      role_arn       = "arn::test"
    }
    ebs_csi = {
      enabled        = true
      namespace      = "dummy"
      serviceaccount = "sa"
      role_arn       = "arn::test"
    }
    argocd = {
      enabled        = true
      namespace      = "dummy"
      serviceaccount = "sa"
    }
    jenkins = {
      enabled        = true
      namespace      = "dummy"
      serviceaccount = "sa"
    }
    loki_stack = {
      enabled                                       = true
      namespace                                     = "dummy"
      serviceaccount                                = "sa"
      ingress_enabled                               = true
      prometheus_server_volume_size                 = "8Gi"
      prometheus_alert_manager_volume_size          = "8Gi"
      loki_volume_size                              = "8Gi"
      github_oauth_client_id             = "dummy"
      github_oauth_client_secret         = "dummy"
      github_oauth_allowed_domains       = []
      github_oauth_allowed_organizations = []
      github_oauth_allowed_team_ids      = []
      github_oauth_enabled               = true
    }
  }
}

dependency "system_charts"{
  config_path = "../020_system_charts"
  skip_outputs = true
}

inputs = {
  cluster_region                                  = dependency.eks.outputs.eks_region
  cluster_name                                    = dependency.eks.outputs.eks_cluster_name
  vpc_id                                          = dependency.eks.outputs.vpc_id
  domain_name                                     = dependency.eks.outputs.r53_zone_name
  acm_certificate_arn                             = dependency.eks.outputs.acm_certificate_arn
  cluster_oidc_provider_arn                       = dependency.eks.outputs.eks_oidc_provider_arn

  #Kubeshark
  kubeshark_enabled                               = true
  kubeshark_namespace                             = "kubeshark"

  # Loki stack
  loki_stack_enabled                              = true
  loki_stack_namespace                            = "loki-stack"
  loki_stack_serviceaccount                       = "loki-stack"
  loki_stack_ingress_enabled                      = true
  loki_stack_prometheus_server_volume_size        = "20Gi"
  loki_stack_prometheus_alert_manager_volume_size = "5Gi"
  loki_stack_loki_volume_size                     = "20Gi"
  loki_stack_github_oauth_client_id               =  "${get_env("github_oauth_client_id", "Please provide a github_oauth_client_id")}" // Create an OAuth app in Github and provide the client id
  loki_stack_github_oauth_client_secret           = "${get_env("github_oauth_client_secret", "Please provide a github_oauth_client_secret")}" // Create an OAuth app in Github and provide the client secret
  # loki_stack_github_oauth_allowed_domains         = ""
  # loki_stack_github_oauth_allowed_organizations   = ""
  # loki_stack_github_oauth_allowed_team_ids        = ""
  loki_stack_github_oauth_enabled                 = false

  #Jaeger
  jaeger_enabled                                  = false
  jaeger_namespace                                = "jaeger"
  jaeger_demo_app_enabled                         = false
}
