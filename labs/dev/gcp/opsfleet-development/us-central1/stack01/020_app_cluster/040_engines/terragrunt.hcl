include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "cloud_specific"{
  path = "../../../../../cloud_specific.hcl"
}

dependency "system_configurations"{
  config_path  = "../030_system_configurations"

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
  source = "../../../../../../../../templates/charts/argo_project"
}

generate "helm_provider" {
  path      = "helm_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    provider "helm" {
    kubernetes {
      host                   = "https://${dependency.gke.outputs.endpoint}"
      cluster_ca_certificate = "${replace(base64decode(dependency.gke.outputs.ca_certificate),"\n", "\\n")}" // replace is used to remove the new line at the end of the certificate
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
      cluster_ca_certificate = "${replace(base64decode(dependency.gke.outputs.ca_certificate),"\n", "\\n")}" // replace is used to remove the new line at the end of the certificate
      exec {
        api_version = "client.authentication.k8s.io/v1beta1"
        command     = "gke-gcloud-auth-plugin"
        args        = ["--cluster", "${dependency.gke.outputs.cluster_name}", "--location", "${dependency.gke.outputs.location}"]
      }
    }
  EOF
}

generate "kubectl_provider"{ // This provider is needed since kubernetes provider does not support "depends_on" and we need to wait for the Argocd to install CRDs before creating project and apps
  path      = "kubectl_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "kubectl" {
    load_config_file       = false
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

  argocd_enabled = true
  argocd_namespace = "argocd"
  argocd_helm_chart_version = "5.41.2"
  argocd_service_account_name = "argocd"
  argocd_hostname = "argocd.${dependency.gke.outputs.cluster_domain}"
  #TODO!: Fix this next Line-> argocd_certificate_issuer_name
  argocd_certificate_issuer_name = dependency.system_configurations.outputs.certificate_issuer_name_production[0] != "" ? dependency.system_configurations.outputs.certificate_issuer_name_production[0] : dependency.system_configurations.outputs.certificate_issuer_name_staging[0]
  #Apps Main Project Creation
  argocd_main_project_name = "main"
  #Initial GitOps Repo - Recommended
  argocd_configure_initial_gitops_repo = true
  argocd_initial_gitops_repo_url = "https://github.com/Opsfleet/gitops.git"
  argocd_initial_gitops_repo_username = "${get_env("repo_username", "Please provide a username")}" // Create an Env Var with your GitServer username
  argocd_initial_gitops_repo_password = "${get_env("repo_password", "Please provide a password")}" // Create an Env Var with your GitServer password
  #SSO
  argocd_configure_sso = true
  argocd_sso_provider = "github" #TODO: google, gitlab, dex
  argocd_sso_client_id = "${get_env("sso_client_id", "Please provide a client id")}" // Create an Env Var with your OAuth client id
  #Client Secret created manually view  - ../../../../../../../templates/charts/argo_project/argocd/README.md
  argocd_sso_org = "Opsfleet"
  argocd_admin_team_name ="argocd-admins"
  #Create Root_Appliation
  argocd_create_root_app = true
  argocd_root_app_name = "app-of-apps"
  argocd_root_app_target_revision = "HEAD"
  argocd_root_app_path = "${local.environment_name}/apps"
  argocd_root_app_destination = "https://kubernetes.default.svc" //This means "in-cluster"
  argocd_root_app_dir_recurse = false
  argocd_root_app_exclude  = ""
}