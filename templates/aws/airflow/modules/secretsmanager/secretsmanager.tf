# Create Secretsmanager secret
resource "aws_secretsmanager_secret" "airflow_secret" {
  name        = "${var.project_prefix}/airflowfdna/${var.project_id}-${var.environment}"
  description = "Airflow secrets for ${var.project_id} instance."
  replica {
    region = var.backup_region
  }
}

# Add key:value pairs to the secret
resource "aws_secretsmanager_secret_version" "airflow_secret_values" {
  secret_id     = aws_secretsmanager_secret.airflow_secret.id
  secret_string = <<EOF
   {
    "fernet_key":"${var.fernet_key}",
    "metadata_store_postgres_db":"airflow",
    "metadata_store_postgres_user":"airflow",
    "metadata_store_postgres_password":"${var.airflow_password}",
    "metadata_store_postgres_host":"${var.metadata_store_postgres_host}",
    "metadata_store_postgres_port":"${var.metadata_store_postgres_port}",
    "metadata_store_full_uri":"postgresql://airflow:${var.airflow_password}@airflow${var.project_id}-pgbouncer.arf${var.project_id}:${var.metadata_store_postgres_port}/airflow?sslmode=disable&default_query_exec_mode=exec",
    "celery_broker_redis_prefix":"rediss://",
    "celery_broker_redis_host":"${var.redis_host}",
    "celery_broker_redis_auth":"${var.redis_auth_token}",
    "celery_broker_redis_dbnum_properties":"1?ssl_cert_reqs=CERT_OPTIONAL",
    "webserver_secret_key":"${var.webserver_secret}",
    "flower_username_password":"${var.flower_ui_access}",
    "ldap_password":"${var.ldap_password}",
    "gitsync_username":"${var.git_sync_github_user}",
    "gitsync_password":"${var.git_sync_github_pat}",
    "airflow_read_password":"${var.airflow_read_password}",
    "postgres_master_password":"${var.postgres_master_password}"
   } 
   EOF
  lifecycle {
    ignore_changes = [
      secret_string,
    ]
  }
}
