# EXTERNAL DNS
module "external-dns" {
  count = var.gke_external_dns_enabled ? 1 : 0
  source = "./gke_external_dns"
  project_id = var.project_id
  cluster_name = var.cluster_name
  region = var.region
  namespace = var.external_dns_namespace
  name = var.external_dns_chart_name
  external_dns_version = "${var.external_dns_chart_version}"
  serviceaccount = var.external_dns_service_account_name
  domain_name = var.external_dns_domain_filter
  extra_values = var.external_dns_extra_values
}

module "cert-manager" {
  count = var.cert_manager_enabled ? 1 : 0
  source = "./certificate_manager"
  cluster_name = var.cluster_name
  namespace = var.cert_manager_namespace
  cert_manager_helm_chart_version = var.cert_manager_helm_chart_version
  cert_manager_issuer_staging_mode = var.cert_manager_issuer_staging_mode
  issuer_email = var.cert_manager_issuer_email
}

module "kong" {
  count = var.kong_enabled ? 1 : 0
  source = "./kong_ingress_controller"
  namespace = var.kong_namespace
  kong_chart_version = var.kong_version
  extra_values = var.kong_extra_values
}