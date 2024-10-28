# Create subnet group for RDS instance
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = var.rds_subnet_group_name
  subnet_ids  = var.rds_subnets
  description = "Subnet group for RDS for Airflow on EKS"
}

# Create custom parameter group for RDS isntance to customize postgres parameters
resource "aws_db_parameter_group" "rds_pg_parameter_group" {
  name        = var.rds_parameter_group_name
  family      = var.rds_parameter_group_family
  description = var.rds_parameter_group_description

  dynamic "parameter" {
    for_each = var.rds_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  lifecycle {
    create_before_destroy = true
  }

}
