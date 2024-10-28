# Values of mandatory Merck tags
common_tags = {
  Environment        = "Test"
  Application        = "aparflow"
  Costcenter         = "10004416"
  Division           = "CTO Org"
  DataClassification = "Proprietary"
  Consumer           = "airflow_eng@merck.com"
  Service            = "aparflow-test"
}

# Main prefix of deployment. Corresponds to CI. For centralized accounts it's aparflow
project_prefix = "aparflow"
# Target AWS region
region = "eu-west-1"
# AWS account number of deployment target
aws_account_number = "015811401862"
# Environment name. dev/sit/uat/prod
environment = "sit"

# ID of target VPC
target_vpc_id = "vpc-00f14f85dc93f2fe6"
# Subnet IDs of Merck routable subnets
routable_subnets = ["subnet-01f639c3461eaf06e", "subnet-0c69bead26cfe21cc"]
# Subnet IDs of Merck non-routable NAT gateway subnets
non_routable_subnets = ["subnet-01e7696b0365114c3", "subnet-0389e799d56f872d8"]

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
