resource "google_service_account" "external_dns_sa" {
  account_id = "${var.cluster_name}-external-dns"
  display_name = "${var.cluster_name}-external-dns"
}

resource "google_project_iam_member" "external_dns_sa" {
  project = var.project_id
  role = "roles/dns.admin"
  member = "serviceAccount:${google_service_account.external_dns_sa.email}"
}
  
resource "google_service_account_iam_member" "external_dns_sa" {
  service_account_id = google_service_account.external_dns_sa.name
  role = "roles/iam.workloadIdentityUser"
  member = "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/${var.name}]"
}