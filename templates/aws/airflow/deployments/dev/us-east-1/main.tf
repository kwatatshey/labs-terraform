# Deploy service IAM roles for EKS cluster and Fargate
module "iam-eks-srv" {
  source = "../../../modules/iam-eks-srv"

  project_prefix                         = var.project_prefix
  region                                 = var.region
  eks_cluster_role_name                  = "${var.project_prefix}-eks-cluster-role"
  eks_fargate_role_name                  = "${var.project_prefix}-eks-fargate-role"
  eks_fargate_logging_policy_name        = "${var.project_prefix}-eks-fargate-logging-policy"
  eks_fargate_logging_policy_description = "Policy to allow fargate send logs to CloudWatch"
}

# Deploy EKS cluster
module "eks" {
  source = "../../../modules/eks"

  eks_cluster_name          = "${var.project_prefix}-airflowfdna-eks-cluster-dev"
  eks_cluster_role_arn      = module.iam-eks-srv.cluster_role_arn
  subnet_ids                = var.eks_routable_subnets
  security_group_names      = var.cluster_security_groups_names
  kubernetes_version        = var.kubernetes_version
  enabled_cluster_log_types = var.enabled_cluster_log_types
  eks_kms_alias             = "alias/eks-kms"
}

# Deploy OIDC Identity provider 
module "oidc" {
  source = "../../../modules/oidc"

  eks_oidc_url = module.eks.oidc_url
}

# Deploy IAM roles to be used by kubernetes pods
module "iam-irsa" {
  source = "../../../modules/iam-irsa"

  project_prefix               = var.project_prefix
  region                       = var.region
  aws_account_number           = var.aws_account_number
  eks_oidc_url                 = module.eks.oidc_url
  eks_pod_role_name            = "${var.project_prefix}-airflow-eks-pod-role"
  eks_alb_role_name            = "${var.project_prefix}-airflow-eks-loadbalancer-controller-role"
  eks_external_dns_role_name   = "airflow-eks-external-dns-role"
  eks_pod_policy_name          = "${var.project_prefix}-airflow-eks-pod-policy"
  eks_alb_policy_name          = "${var.project_prefix}-airflow-eks-loadbalancer-controller-policy"
  eks_external_dns_policy_name = "${var.project_prefix}-airflow-eks-external-dns-policy"
  eks_pod_policy_description   = "Managed Policy for role to be assumed by Airflow pods."
  eks_alb_policy_description   = "Policy to be used by a Load balancer controller pod to manage provisioning of load balancers for EKS cluster."
}

# Deploy Fargate profile for infra kubernetes components
module "eks-fargate-infra" {
  source = "../../../modules/eks-fargate-infra"

  cluster_name     = module.eks.cluster_name
  profile_name     = "${var.project_prefix}-eks-airflfow-fargate-infra"
  fargate_role_arn = module.iam-eks-srv.fargate_role_arn
  subnet_ids       = var.non_routable_subnets
  coredns_replicas = var.coredns_replicas
  vpc_cni_addon_version    = var.vpc_cni_addon_version
  coredns_addon_version    = var.coredns_addon_version
  kube_proxy_addon_version = var.kube_proxy_addon_version
}

# Deploy S3 bucket for Airflow logs
module "s3" {
  source = "../../../modules/s3"

  bucket_name = "${var.project_prefix}-airflowfdna-task-logs-${var.region}-${var.environment}"
}

# Deploy subnet group and security group for Elasticache Redis
module "redis-support" {
  source = "../../../modules/redis-support"

  redis_sg_name           = "${var.project_prefix}-airflowfdna-redis-sg"
  redis_sg_description    = "${var.project_prefix}-airflowfdna-redis-sg"
  redis_subnet_group_name = "${var.project_prefix}-airflowfdna-redis-subnetgroup"
  redis_vpc_id            = var.target_vpc_id
  redis_subnets           = var.routable_subnets
}

# Deploy subnet group and parameter group for RDS
module "rds-support" {
  source = "../../../modules/rds-support"

  rds_subnet_group_name           = "${var.project_prefix}-airflowfdna-metadata-subnetgroup"
  rds_subnets                     = var.routable_subnets
  rds_parameter_group_name        = "${var.project_prefix}-eks-postgrespg14"
  rds_parameter_group_description = "Postgres parameter group for Airflow on EKS version 14 - adjusted password encryption to md5 and max connection increased"
  rds_parameter_group_family      = var.rds_parameter_group_family
  rds_parameters                  = var.rds_parameters
}


# Deploy EFS drive with mount targets and access point for prometheus
module "efs" {
  source = "../../../modules/efs"

  efs_name                  = "${var.project_prefix}-airflowfdna-efs-${var.environment}"
  creation_token            = "quickCreated-1e090885-2bd2-45bc-96ee-6459c4075ffa"
  efs_throughput_mode       = var.efs_throughput_mode
  efs_mount_targets_subnets = var.eks_routable_subnets
  efs_mount_targets_sg      = var.cluster_security_groups_names
  efs_ap_name               = "${var.project_prefix}-airflowfdna-efs-prometheus-ap"
}
