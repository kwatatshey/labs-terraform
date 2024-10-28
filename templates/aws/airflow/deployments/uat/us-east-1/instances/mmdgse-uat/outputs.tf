output "efs_access_point_id" {
  value       = module.efs-proj.efs_access_point_id
  description = "efs access point id - needed for aurflow-instance.yaml"
}