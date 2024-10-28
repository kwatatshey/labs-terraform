variable "common_tags" {
  description = "Common tags to be assigned across infrastructure pieces"
  type        = map(string)
}

variable "project_prefix" {
  type        = string
  description = "AWS account prefix to be used for the given project."
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "Environment of deployment. dev/test/uat/prod"
}

variable "non_routable_subnets" {
  type        = list(any)
  description = "List of subnet IDs that the k8s pods will be deployed in. Merck non routables"
}

variable "project_id" {
  type        = string
  description = "ID that will uniquely identify given project instance  "
}

variable "backup_region" {
  type        = string
  description = "Region to for duplication of secrets or rds snapshot for DR purposes"
}

variable "rds_allocated_storage" {
  type = number
}

variable "rds_engine_version" {
  type = string
}

variable "rds_instance_class" {
  type = string
}

variable "rds_parameter_group_family" {
  type = string
}

variable "rds_vpc_security_group_names" {
  type = list(string)
}

variable "rds_port" {
  type = number
}

variable "rds_storage_type" {
  type = string
}

variable "rds_backup_retention_period" {
  type = number
}

variable "rds_delete_protection" {
  type = bool
}

variable "rds_replica_kms_key_name" {
  type = string
}

variable "rds_maintenance_window" {
  type = string
}

variable "rds_backup_window" {
  type = string
}

variable "redis_multi_az_enabled" {
  type        = bool
  description = "Elasticache with Multi AZ enabled"
}

variable "redis_node_type" {
  type        = string
  description = "The compute and memory capacity of the nodes in the node group."
}

variable "redis_num_cache_clusters" {
  type = number
}

variable "redis_port" {
  type        = number
  description = "The port number on which each of the cache nodes will accept connections."
}

variable "redis_parameter_group" {
  type        = string
  description = "Parameter group for redis elasticache"
}


variable "redis_engine_version" {
  type        = string
  description = "The version number of the cache engine to be used for the cache clusters in this replication group."
}

variable "redis_maintenance_window" {
  type        = string
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed."
}

variable "secretsmanager_common_secrets_name" {
  type        = string
  description = "Name of secret with common secrets"
}

variable "redis_automatic_failover" {
  type        = bool
  description = "Automatic failover primary to replica. For single node set to false."
}