module "dns-public-zone" {
  source  = "terraform-google-modules/cloud-dns/google"
  # version = "4.0"
  project_id = "${var.project_id}"
  type       = "public"
  name       = replace("${var.cluster_name}.${var.cluster_parent_hosted_zone}", ".", "-")
  domain     = "${var.cluster_name}.${var.cluster_parent_hosted_zone}."

  private_visibility_config_networks = [
    "https://www.googleapis.com/compute/v1/projects/${var.project_id}/global/networks/${var.network_name}"
  ]
}

resource "google_dns_record_set" "zone_subzone_ns" {
  name = "${var.cluster_name}.${var.cluster_parent_hosted_zone}."
  type = "NS"
  ttl  = 300

  managed_zone = replace(var.cluster_parent_hosted_zone, ".", "-")

  rrdatas = module.dns-public-zone.name_servers
}