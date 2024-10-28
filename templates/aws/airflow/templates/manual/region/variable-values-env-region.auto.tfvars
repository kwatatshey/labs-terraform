# Values of mandatory Merck tags
common_tags = {
  Environment        = "<Env>"
  Application        = "aparflow"
  Costcenter         = "10004416"
  Division           = "CTO Org"
  DataClassification = "Proprietary"
  Consumer           = "airflow_eng@merck.com"
  Service            = "aparflow-<env>"
}

# Main prefix of deployment. Corresponds to CI. For centralized accounts it's aparflow
project_prefix = "aparflow"
# Target AWS region
region = "<region>"
# AWS account number of deployment target
aws_account_number = "<account number>"
# Environment name. dev/sit/uat/prod
environment = "<env>"

# ID of target VPC
target_vpc_id = "<vpc-123>"
# Subnet IDs of Merck routable subnets
routable_subnets = ["subnet-123", "subnet-456"]
# Subnet IDs of Merck non-routable NAT gateway subnets
non_routable_subnets = ["subnet-789", "subnet-012"]

# Names of security groups that will attached to EKS cluster 
cluster_security_groups_names = ["default", "mcs-baseline-sg-global"]
# Version of kubernetes
kubernetes_version = "1.25"
# Setup of what logs produced by EKS are exported to Cloudwatch
enabled_cluster_log_types = ["audit", "authenticator"]

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
