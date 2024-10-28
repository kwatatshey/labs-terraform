# Deploy service IAM roles for EKS cluster and Fargate
module "iam-eks-srv" {
  source = "../../modules/iam-eks-srv"

  project_prefix = var.project_prefix
  region         = var.region
}

# Deploy EKS cluster
module "eks" {
  source = "../../modules/eks"

  eks_cluster_name          = "${var.project_prefix}-airflow-eks-cluster"
  eks_cluster_role_arn      = module.iam-eks-srv.cluster_role_arn
  subnet_ids                = var.routable_subnets
  security_group_names      = var.cluster_security_groups_names
  kubernetes_version        = var.kubernetes_version
  enabled_cluster_log_types = var.enabled_cluster_log_types
  eks_kms_alias             = "alias/eks-kms-sbx"
}

# Deploy OIDC Identity provider 
module "oidc" {
  source = "../../modules/oidc"

  eks_oidc_url = module.eks.oidc_url
}

# Deploy IAM roles to be used by kubernetes pods
module "iam-irsa" {
  source = "../../modules/iam-irsa"

  project_prefix     = var.project_prefix
  region             = var.region
  aws_account_number = var.aws_account_number
  eks_oidc_url       = module.eks.oidc_url
}

# Deploy Fargate profile for infra kubernetes components
module "eks-fargate-infra" {
  source = "../../modules/eks-fargate-infra"

  cluster_name     = module.eks.cluster_name
  profile_name     = "${var.project_prefix}-airflowfdna-eks-fargate-infra"
  fargate_role_arn = module.iam-eks-srv.fargate_role_arn
  subnet_ids       = var.non_routable_subnets
  vpc_cni_addon_version    = var.vpc_cni_addon_version
  coredns_addon_version    = var.coredns_addon_version
  kube_proxy_addon_version = var.kube_proxy_addon_version
}

# Deploy S3 bucket for Airflow logs
module "s3" {
  source = "../../modules/s3"

  bucket_name = "${var.project_prefix}-airflowfdna-task-logs-${var.region}-${var.environment}"
}


# Deploy subnet group and parameter group for RDS
module "rds-support" {
  source = "../../modules/rds-support"

  rds_subnet_group_name      = "${var.project_prefix}-airflowfdna-metadata-subnetgroup"
  rds_subnets                = var.routable_subnets
  rds_parameter_group_name   = "${var.project_prefix}-eks-pg${var.rds_parameter_group_family}"
  rds_parameter_group_family = var.rds_parameter_group_family
  rds_parameters             = var.rds_parameters
}

# Create fargate profile in existing EKS cluster for namespace where Airflow instance will run.
module "eks-fargate-proj" {
  source = "../../modules/eks-fargate-proj"

  cluster_name      = "${var.project_prefix}-airflow-eks-cluster"
  profile_name      = "${var.project_prefix}-airflowfdna-eks-fargate-instances"
  fargate_role_name = "${var.project_prefix}-airflow-eks-fargate-role-${var.region}"
  subnet_ids        = var.non_routable_subnets
  namespace         = "arfsbx"
}

# Pull secrets from pre-created secret manager
data "aws_secretsmanager_secret" "secrets" {
  name = var.secretsmanager_sandbox_secrets_name
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}

locals {
  credentials = jsondecode(
    data.aws_secretsmanager_secret_version.current.secret_string
  )
}

# Create Postgres RDS for Airflow metadata database
module "rds-sbx" {
  source = "../../modules/rds-sbx"

  identifier                = "${var.project_prefix}-airflowfdna-metadata-sandbox-instances"
  allocated_storage         = var.rds_allocated_storage
  engine_version            = var.rds_engine_version
  instance_class            = var.rds_instance_class
  password                  = local.credentials.rds_postgres_master_password
  parameter_group_name      = "${var.project_prefix}-eks-pg${var.rds_parameter_group_family}"
  db_subnet_group_name      = "${var.project_prefix}-airflowfdna-metadata-subnetgroup"
  security_group_names      = var.rds_vpc_security_group_names
  port                      = var.rds_port
  final_snapshot_identifier = "${var.project_prefix}-airflowfdna-metadata-sandboxes-${var.environment}-final-snapshot"
  storage_type              = var.rds_storage_type
  backup_retention_period   = var.rds_backup_retention_period
  delete_protection         = var.rds_delete_protection
  replica_kms_key_name      = var.rds_replica_kms_key_name
  maintenance_window        = var.rds_maintenance_window
  backup_window             = var.rds_backup_window
  airflow_password          = local.credentials.rds_airflow_password
  airflow_read_password     = local.credentials.rds_airflow_read_password

  providers = {
    aws.main    = aws
    aws.replica = aws.replica
  }
}
