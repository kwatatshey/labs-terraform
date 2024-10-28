# Output OIDC URL to be used be Identity provider and IAM roles
output "oidc_url" {
  value       = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
  description = "Value of OIDC url for this cluster"
}

# Output cluster name to be used by other modules
output "cluster_name" {
  value       = aws_eks_cluster.eks_cluster.name
  description = "Name of the cluster"
}