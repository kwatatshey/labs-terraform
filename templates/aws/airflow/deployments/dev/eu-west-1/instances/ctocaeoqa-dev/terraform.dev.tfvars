# Values of mandatory Merck tags and tag to identify project
common_tags = {
  Environment        = "Development"
  Application        = "ingest"
  Costcenter         = "10004416"
  Division           = "CTO Org"
  DataClassification = "Proprietary"
  Consumer           = "airflow_eng@merck.com"
  Service            = "aparflow-Development"
  Project            = "ctocaeoqa"
}

# Main prefix of deployment. Corresponds to CI.
project_prefix = "aparflow"
# Target AWS region
region = "eu-west-1"
# Environment name. dev/sit/uat/prod
environment = "dev"
# Subnet IDs of Merck non-routable NAT gateway subnets
non_routable_subnets = ["subnet-0731c7a37e4e583d2", "subnet-092a4e862bea3253c"]
# Region for cross regional backups
backup_region = "us-east-1"

# Unique ID of project that this Airflow instance belongs to. Consist of division+project. E.g. mrlsls
project_id = "ctocaeoqa"

# Configuration for RDS database
rds_allocated_storage        = 50
rds_engine_version           = "14.12"
rds_instance_class           = "db.t3.small"
rds_parameter_group_family   = "postgres14"
rds_vpc_security_group_names = ["default", "mcs-baseline-sg-rds"]
rds_port                     = 5432
rds_storage_type             = "gp3"
rds_backup_retention_period  = 7
rds_delete_protection        = false
rds_replica_kms_key_name     = "mcs-kms"
rds_maintenance_window       = "Wed:06:00-Wed:06:30"
rds_backup_window            = "05:00-05:30"

# Configuration of Elasticache Redis
redis_multi_az_enabled   = false
redis_node_type          = "cache.t4g.micro"
redis_num_cache_clusters = 1
redis_port               = 6379
redis_parameter_group    = "default.redis7"
redis_engine_version     = "7.0"
redis_maintenance_window = "Wed:05:30-Wed:06:30"
redis_automatic_failover = false

# Name of AWS Secretsmanager secret in us-east-1 region that contains common sensitive values(reused across instances)
secretsmanager_common_secrets_name = "aparflow/airflowfdna/commonsecrets"
