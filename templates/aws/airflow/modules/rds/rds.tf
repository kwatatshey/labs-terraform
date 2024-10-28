# Requires two providers due to usage of two AWS regions. One for RDS instance and second for cross-region RDS backup.
terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.0.0"
      configuration_aliases = [aws.main, aws.replica]
    }
  }
}

# Pull info about security groups that will be attached to RDS instance.
data "aws_security_group" "rds_sg" {
  for_each = toset(var.security_group_names)
  name     = each.value

  provider = aws.main
}

# Create Postgres RDS instance to be used as Airflow metadata database.
resource "aws_db_instance" "metadatapgrds" {
  identifier                      = var.identifier
  allocated_storage               = var.allocated_storage
  engine                          = "postgres"
  engine_version                  = var.engine_version
  instance_class                  = var.instance_class
  db_name                         = "postgres"
  username                        = "postgres"
  password                        = var.password
  parameter_group_name            = var.parameter_group_name
  db_subnet_group_name            = var.db_subnet_group_name
  vpc_security_group_ids          = [for sg in data.aws_security_group.rds_sg : sg.id]
  port                            = var.port
  skip_final_snapshot             = false
  final_snapshot_identifier       = var.final_snapshot_identifier
  storage_type                    = var.storage_type
  storage_encrypted               = true
  performance_insights_enabled    = true
  max_allocated_storage           = 0
  maintenance_window              = var.maintenance_window
  backup_window                   = var.backup_window
  backup_retention_period         = var.backup_retention_period
  deletion_protection             = var.delete_protection
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  copy_tags_to_snapshot           = true
  delete_automated_backups        = false
  apply_immediately               = true


  provider = aws.main

  tags = {
    CoreInfraTag-Backup             = "No"
    CoreInfraTag-BackupCopyToBunker = "No"
  }
}

# Pull info about KMS key from replica region that will encrypt cross-region backup
data "aws_kms_key" "rds_replica_key" {
  key_id = "alias/${var.replica_kms_key_name}"

  provider = aws.replica
}

# Setup cross-region backup replication
resource "aws_db_instance_automated_backups_replication" "metadatapgrds" {
  source_db_instance_arn = aws_db_instance.metadatapgrds.arn
  kms_key_id             = data.aws_kms_key.rds_replica_key.arn
  retention_period       = var.backup_retention_period

  provider = aws.replica
}

# Output RDS instance hostname
output "rds_host" {
  value       = aws_db_instance.metadatapgrds.address
  description = "Hostname of RDS instance"
}

# Execute SQL script to create "airflow" database and "airflow" user
resource "null_resource" "create_airflow_user" {

  provisioner "local-exec" {

    command = "psql -v airflow_password=\"'${var.airflow_password}'\" -h ${aws_db_instance.metadatapgrds.address} -p ${var.port} -U postgres -d postgres -f \"../../../../../scripts/create_airflow_user.sql\""

    environment = {
      PGPASSWORD = "${var.password}"
    }
  }
  depends_on = [
    aws_db_instance.metadatapgrds
  ]
}

# Execute SQL script to create "airflow_read" user
resource "null_resource" "create_airflow_read_user" {

  provisioner "local-exec" {

    command = "psql -v airflow_read_password=\"'${var.airflow_read_password}'\" -h ${aws_db_instance.metadatapgrds.address} -p ${var.port} -U postgres -d airflow -f \"../../../../../scripts/create_airflow_read_user.sql\""

    environment = {
      PGPASSWORD = "${var.password}"
    }
  }
  depends_on = [
    null_resource.create_airflow_user
  ]
}

# Execute SQL script to give read access to "airflow" database to "airflow_read" user
resource "null_resource" "grant_airflow_read_access" {

  provisioner "local-exec" {

    command = "psql -h ${aws_db_instance.metadatapgrds.address} -p ${var.port} -U airflow -d airflow -f \"../../../../../scripts/grant_airflow_read_access.sql\""

    environment = {
      PGPASSWORD = "${var.airflow_password}"
    }
  }
  depends_on = [
    null_resource.create_airflow_read_user
  ]
}
