output "cluster_name" {
  value       = module.eks.cluster_name
  description = "cluster_name - needed for restart deployments"
}