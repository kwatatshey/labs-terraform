include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "cloud_specific" {
  path = "../../../../../cloud_specific.hcl"
}

dependency "gke" {
  config_path = "../010_gke"
  mock_outputs = {
    cluster_domain = "https://stam.com",
    endpoint       = "mock-endpoint",
    token          = "lsdnakm"
    ca_certificate = "bW9jay1lbmRwb2ludA=="
    location       = "somewhere"
  cluster_name = "mock-gke-cluster-name" }
}

dependency "vpc" {
  config_path = "../../010_vpc_public"
  mock_outputs = {
    project_id = "mock-project-id"
  }
}

terraform {
  source = "../../../../../../../../templates/gcp/charts/system_charts"
}

generate "helm_provider" {
  path      = "helm_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    provider "helm" {
    kubernetes {
      host                   = "https://${dependency.gke.outputs.endpoint}"
      cluster_ca_certificate = "${replace(base64decode(dependency.gke.outputs.ca_certificate), "\n", "\\n")}" // replace is used to remove the new line at the end of the certificate
      exec {
        api_version = "client.authentication.k8s.io/v1beta1"
        command     = "gke-gcloud-auth-plugin"
        args        = ["--cluster", "${dependency.gke.outputs.cluster_name}", "--location", "${dependency.gke.outputs.location}"]
      }
    }
  }
  EOF
}

generate "provider-local" {
  path      = "kubernetes_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    provider "kubernetes" {
      host                   = "https://${dependency.gke.outputs.endpoint}"
      cluster_ca_certificate = "${replace(base64decode(dependency.gke.outputs.ca_certificate), "\n", "\\n")}" // replace is used to remove the new line at the end of the certificate
      exec {
        api_version = "client.authentication.k8s.io/v1beta1"
        command     = "gke-gcloud-auth-plugin"
        args        = ["--cluster", "${dependency.gke.outputs.cluster_name}", "--location", "${dependency.gke.outputs.location}"]
      }
    }
  EOF
}

locals {
  environment_name           = include.root.locals.environment_specific_config.locals.environment
  cluster_parent_hosted_zone = include.root.locals.account_specific_config.locals.parent_zone_id
  region_name                = include.root.locals.region_specific_config.locals.region
  stack_name                 = include.root.locals.stack_specific_config.locals.stack_name
}

inputs = {
  project_id   = "${dependency.vpc.outputs.project_id}"
  cluster_name = "${local.stack_name}-${local.environment_name}-gke"
  region       = local.region_name

  gke_external_dns_enabled          = true
  external_dns_namespace            = "external-dns"
  external_dns_version              = "1.12.0"
  external_dns_service_account_name = "external-dns"
  external_dns_domain_filter        = dependency.gke.outputs.cluster_domain
  external_dns_extra_values         = {}

  cert_manager_enabled             = true
  cert_manager_namespace           = "cert-manager"
  cert_manager_helm_chart_version  = "v1.11.0"
  cert_manager_issuer_staging_mode = true
  cert_manager_issuer_email        = "assafushy@gmail.com"

  kong_enabled   = true
  kong_namespace = "kong"
  kong_version   = "2.26.3"
}

