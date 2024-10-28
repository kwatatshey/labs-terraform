# Pull info about EFS drive that access point will attach to
data "aws_efs_file_system" "efs_drive" {
  tags = {
    Name = var.efs_name
  }
}

# Create an access point to store project's Airflow DAGs
resource "aws_efs_access_point" "access_point_efs" {
  file_system_id = data.aws_efs_file_system.efs_drive.id
  root_directory {
    path = var.efs_path
    creation_info {
      owner_gid   = "5000"
      owner_uid   = "5000"
      permissions = "0777"
    }
  }
  posix_user {
    gid = "5000"
    uid = "5000"
  }
  tags = {
    Name = var.efs_ap_name
  }
}
