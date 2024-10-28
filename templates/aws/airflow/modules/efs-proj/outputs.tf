output "efs_access_point_id" {
  value       = aws_efs_access_point.access_point_efs.id
  description = "efs access point id - needed for airflow-instance.yaml for CB run"
}