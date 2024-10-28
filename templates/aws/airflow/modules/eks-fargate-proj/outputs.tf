output "cluster_name" {
  value       = aws_eks_fargate_profile.eks_fargate_profile_app.cluster_name
  description = "cluster_name - needed for airflow-instance.yaml for CB run"
}