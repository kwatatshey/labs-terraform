# Generate fernet key for Airflow
resource "random_id" "fernet_key" {
  byte_length = 32
}

# Generate random password for airflow metadata DB user
resource "random_password" "airflow_pw" {
  length           = 15
  special          = false
  override_special = "=!.$-_"
  min_numeric      = 2
  min_special      = 0
  min_upper        = 3
}

# Generate random password for airflow_read metadata DB user
resource "random_password" "airflow_read_pw" {
  length           = 15
  special          = false
  override_special = "=!.$-_"
  min_numeric      = 2
  min_special      = 0
  min_upper        = 3
}

# Pull common secrets from secrets manager. Secret has to be previously manually created in us-east-1 region.
data "aws_secretsmanager_secret" "secrets" {
  name     = var.secretsmanager_common_secrets_name
  provider = aws.secrets
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
  provider  = aws.secrets
}

locals {
  credentials = jsondecode(
    data.aws_secretsmanager_secret_version.current.secret_string
  )
}

# Create fargate profile in existing EKS cluster for namespace where Airflow instance will run.
module "eks-fargate-proj" {
  source = "../../../../../modules/eks-fargate-proj"

  cluster_name      = "${var.project_prefix}-airflow-eks-cluster"
  profile_name      = "${var.project_prefix}-airflowfdna-eks-fargate-${var.project_id}"
  fargate_role_name = "${var.project_prefix}-airflow-eks-fargate-role-${var.region}"
  subnet_ids        = var.non_routable_subnets
  namespace         = "arf${var.project_id}"
}

# Create EFS Access point in region EFS drive where DAGs for given Airflow instance will be stored.
module "efs-proj" {
  source = "../../../../../modules/efs-proj"

  efs_name    = "${var.project_prefix}-airflowfdna-efs-${var.environment}"
  efs_path    = "/${var.project_id}_dags"
  efs_ap_name = "${var.project_prefix}-airflowfdna-efs-ap-${var.project_id}"
}

# Create Postgres RDS for Airflow metadata database
module "rds" {
  source = "../../../../../modules/rds"

  identifier                = "${var.project_prefix}-airflowfdna-metadata-${var.project_id}-${var.environment}"
  allocated_storage         = var.rds_allocated_storage
  engine_version            = var.rds_engine_version
  instance_class            = var.rds_instance_class
  password                  = local.credentials.rds_postgres_master_password
  parameter_group_name      = "${var.project_prefix}-eks-pg${var.rds_parameter_group_family}"
  db_subnet_group_name      = "${var.project_prefix}-airflowfdna-metadata-subnetgroup"
  security_group_names      = var.rds_vpc_security_group_names
  port                      = var.rds_port
  final_snapshot_identifier = "${var.project_prefix}-airflowfdna-metadata-${var.project_id}-${var.environment}-final-snapshot"
  storage_type              = var.rds_storage_type
  backup_retention_period   = var.rds_backup_retention_period
  delete_protection         = var.rds_delete_protection
  replica_kms_key_name      = var.rds_replica_kms_key_name
  maintenance_window        = var.rds_maintenance_window
  backup_window             = var.rds_backup_window
  airflow_password          = random_password.airflow_pw.result
  airflow_read_password     = random_password.airflow_read_pw.result

  providers = {
    aws.main    = aws
    aws.replica = aws.replica
  }
}

# Create elasticache Redis. Is used as message broker for Celery.
module "redis" {
  source = "../../../../../modules/redis"

  auth_token           = local.credentials.redis_auth
  replication_group_id = "${var.project_prefix}-airflowfdna-redis-${var.project_id}-${var.environment}"
  multi_az_enabled     = var.redis_multi_az_enabled
  node_type            = var.redis_node_type
  num_cache_clusters   = var.redis_num_cache_clusters
  port                 = var.redis_port
  parameter_group      = var.redis_parameter_group
  subnet_group_name    = "${var.project_prefix}-airflowfdna-redis-subnetgroup"
  engine_version       = var.redis_engine_version
  security_group_name  = "${var.project_prefix}-airflowfdna-redis-sg"
  maintenance_window   = var.redis_maintenance_window

}

# Create secret in AWS secrets manager with sensitive values that are needed by Airflow instance.
module "secretsmanager" {
  source = "../../../../../modules/secretsmanager"

  project_prefix               = var.project_prefix
  project_id                   = var.project_id
  environment                  = var.environment
  backup_region                = var.backup_region
  fernet_key                   = "${random_id.fernet_key.b64_url}="
  metadata_store_postgres_host = module.rds.rds_host
  metadata_store_postgres_port = var.rds_port
  redis_host                   = module.redis.redis_host
  redis_auth_token             = local.credentials.redis_auth
  webserver_secret             = local.credentials.webserver_secret
  flower_ui_access             = local.credentials.flower_ui_access
  ldap_password                = local.credentials.ldap_password
  git_sync_github_user         = local.credentials.git_sync_github_user
  git_sync_github_pat          = local.credentials.git_sync_github_pat
  airflow_password             = random_password.airflow_pw.result
  airflow_read_password        = random_password.airflow_read_pw.result
  postgres_master_password     = local.credentials.rds_postgres_master_password
}
