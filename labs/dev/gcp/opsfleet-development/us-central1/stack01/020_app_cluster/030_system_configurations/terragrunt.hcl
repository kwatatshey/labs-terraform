include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "cloud_specific"{
  path = "../../../../../cloud_specific.hcl"
}

dependency "system_charts" {
  config_path  = "../020_system_charts"
  mock_outputs = {
 }
}

dependency "gke" {
  config_path  = "../010_gke"
  mock_outputs = {
    cluster_domain       = "https://stam.com",
    endpoint             = "mock-endpoint",
    token = "lsdnakm"
    ca_certificate = "bW9jay1lbmRwb2ludA=="
 }
}

dependency "vpc" {
  config_path  = "../../010_vpc_public"
  mock_outputs = {
    project_id       = "mock-project-id"
  }
}

terraform {
  source = "../../../../../../../../templates/charts/system_configurations"
}

generate "provider-local" {
  path      = "kubernetes_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    provider "kubernetes" {
      host                   = "https://${dependency.gke.outputs.endpoint}"
      cluster_ca_certificate = "${replace(base64decode(dependency.gke.outputs.ca_certificate),"\n", "\\n")}" // replace is used to remove the new line at the end of the certificate
      exec {
        api_version = "client.authentication.k8s.io/v1beta1"
        command     = "gke-gcloud-auth-plugin"
        args        = ["--cluster", "${dependency.gke.outputs.cluster_name}", "--location", "${dependency.gke.outputs.location}"]
      }
    }
  EOF
}

locals {
  environment_name = include.root.locals.environment_specific_config.locals.environment
  cluster_parent_hosted_zone = include.root.locals.account_specific_config.locals.parent_zone_id
  region_name      = include.root.locals.region_specific_config.locals.region
  stack_name       = include.root.locals.stack_specific_config.locals.stack_name
}

inputs = {
  project_id          = "${dependency.vpc.outputs.project_id}"
  cluster_name        = "${local.stack_name}-${local.environment_name}-gke"
  region = local.region_name
  
  cert_manager_issuer_staging_mode = false
  cert_manager_issuer_production_mode = true
  cert_manager_issuer_email = "assafushy@gmail.com"  
  ingress_class_name = "kong"
}
  
