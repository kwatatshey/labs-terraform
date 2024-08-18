output "cluster_name" {
  value = module.gke[0].name
}
  
output "cluster_domain" {
  value = module.dns-public-zone.domain
}
output "endpoint" {
  value = module.gke[0].endpoint
  sensitive = true
}
output "ca_certificate" {
  value = module.gke[0].ca_certificate
  sensitive = true
}
output "location" {
  value = module.gke[0].location  
}