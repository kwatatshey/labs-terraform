# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

module "gke" {
  count                      = var.gke_count
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.project_id
  name                       = var.cluster_name
  # region                     = "us-central1" - OPTIONAL, needed only for regional clusters
  zones                      = var.zones
  network                    = var.network_name
  subnetwork                 = var.subnetwork
  default_max_pods_per_node  = 30  // Default is 110, But we need to reduce it to avoid quota issues(Since each node will reserve all IPs for each pods)
  ip_range_pods              = var.ip_range_pods
  ip_range_services          = var.ip_range_services
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = false
  filestore_csi_driver        = false
  remove_default_node_pool   = true
  regional                   = false
  identity_namespace         = "enabled" //The workload pool to attach all Kubernetes service accounts to. (Default value of `enabled` automatically sets project-based pool `[project_id].svc.id.goog`)

  node_pools = [
    {
      name                      = "spot-node-pool"
      machine_type              = "e2-medium"
      # node_locations            = "${var.region}-a"
      min_count                 = 3
      max_count                 = 5
      local_ssd_count           = 0
      spot                      = true
      disk_size_gb              = 100
      disk_type                 = "pd-standard"
      image_type                = "COS_CONTAINERD"
      enable_gcfs               = false
      enable_gvnic              = false
      auto_repair               = true
      auto_upgrade              = true
      # service_account           = "project-service-account@<PROJECT ID>.iam.gserviceaccount.com"
      preemptible               = false
      initial_node_count        = 3
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}
  }

  node_pools_metadata = {
    all = {}
  }

  node_pools_taints = {
    all = []
  }

  node_pools_tags = {
    all = []
  }
}


# provider "kubernetes" {
#   host                   = "https://${module.gke[0].endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(module.gke[0].ca_certificate)
# }

# provider "helm" {
#   kubernetes {
#     host                   = "https://${module.gke[0].endpoint}"
#     token                  = data.google_client_config.default.access_token
#     cluster_ca_certificate = base64decode(module.gke[0].ca_certificate)
#   }
# }

# module "system_charts" {
#   depends_on = [ module.gke ]
#   source = "./system-charts"
#   external_dns_enabled = var.external_dns_enabled
#   project_id = var.project_id
#   cluster_name = module.gke[0].name
#   region = var.region
#   //External DNS vars
#   external_dns_namespace = var.external_dns_namespace
#   external_dns_chart_name = var.external_dns_chart_name
#   external_dns_chart_version = var.external_dns_chart_version
#   external_dns_service_account_name = var.external_dns_service_account_name
#   external_dns_domain_filter = module.dns-public-zone.domain
#   external_dns_extra_values = var.external_dns_extra_values
#   //Cert Manager vars
#   cert_manager_enabled = var.cert_manager_enabled
#   cert_manager_namespace = "cert-manager"
#   cert_manager_helm_chart_version = "v1.11.0"
#   cert_manager_issuer_staging_mode = var.cert_manager_issuer_staging_mode
#   cert_manager_issuer_email = var.cert_manager_issuer_email
# }

# # module "argo-project" {
# #   source = "./argo-project"
# #   certificate_issuer_name = module.system_charts.certificate_issuer_name
# # }

