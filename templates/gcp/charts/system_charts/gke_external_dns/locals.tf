locals {
  base_values = templatefile("${path.module}/values.yaml", {
    release_name = var.name
    sa_name      = var.serviceaccount
    identity_workload_sa_binding ="${var.cluster_name}-external-dns@${var.project_id}.iam.gserviceaccount.com"
    domain       = trimsuffix(var.domain_name,".") // removes last "." in google cluster domain
    cluster_name = var.cluster_name
    region       = var.region
  })
}
