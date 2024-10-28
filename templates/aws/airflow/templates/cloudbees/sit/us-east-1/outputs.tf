output "cluster_name" {
  value       = module.eks-fargate-proj.cluster_name
  description = "cluster_name - needed for airflow-instance.yaml"
}