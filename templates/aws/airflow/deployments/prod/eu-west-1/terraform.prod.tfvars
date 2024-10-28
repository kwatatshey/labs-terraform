# Values of mandatory Merck tags
common_tags = {
  Environment        = "Production"
  Application        = "aparflow"
  Costcenter         = "10004416"
  Division           = "CTO Org"
  DataClassification = "Proprietary"
  Consumer           = "airflow_eng@merck.com"
  Service            = "aparflow-production"
}

# Main prefix of deployment. Corresponds to CI. For centralized accounts it's aparflow
project_prefix = "aparflow"
# Target AWS region
region = "eu-west-1"
# AWS account number of deployment target
aws_account_number = "806735670197"
# Environment name. dev/sit/uat/prod
environment = "prod"

# ID of target VPC
target_vpc_id = "vpc-0e9773141444f3753"
# Subnet IDs of Merck routable subnets
routable_subnets = ["subnet-044c022a5c76a60ea", "subnet-0127ae87c365cd28d"]
# Subnet IDs of Merck non-routable NAT gateway subnets
non_routable_subnets = ["subnet-02fec1d22cf42c5f0", "subnet-0980773893201fc38"]

# Names of security groups that will attached to EKS cluster 
cluster_security_groups_names = ["default", "mcs-baseline-sg-global"]
# Version of kubernetes
kubernetes_version = "1.29"
# Setup of what logs produced by EKS are exported to Cloudwatch
enabled_cluster_log_types = ["audit", "authenticator"]

# EKS addon versions
vpc_cni_addon_version    = "v1.18.3-eksbuild.1"
coredns_addon_version    = "v1.10.1-eksbuild.7"
kube_proxy_addon_version = "v1.28.6-eksbuild.2"

# EFS drive throughput mode
efs_throughput_mode = "elastic"

# Number of coredns pod replicas
coredns_replicas = 2

# Name of RDS parameter group family
rds_parameter_group_family = "postgres14"
# Custom RDS parameters to customize RDS DB setup
rds_parameters = [
  {
    name         = "password_encryption"
    value        = "md5"
    apply_method = "pending-reboot"
  },
  {
    name         = "max_connections"
    value        = "LEAST({DBInstanceClassMemory/953139},9000)"
    apply_method = "pending-reboot"
  },
]
