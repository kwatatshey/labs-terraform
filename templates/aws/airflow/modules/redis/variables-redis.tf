variable "auth_token" {
  type        = string
  description = "Authorization token to redis elasticache"
}

variable "replication_group_id" {
  type        = string
  description = "The replication group identifier. This parameter is stored as a lowercase string."
}

variable "multi_az_enabled" {
  type        = bool
  description = "Elasticache with Multi AZ enabled"
}

variable "node_type" {
  type        = string
  description = "The compute and memory capacity of the nodes in the node group."
}

variable "num_cache_clusters" {
  type = number
}

variable "port" {
  type        = number
  description = "The port number on which each of the cache nodes will accept connections."
}

variable "parameter_group" {
  type        = string
  description = "Parameter group for redis elasticache"
}

variable "subnet_group_name" {
  type        = string
  description = "Name of Redis subnet group"
}

variable "engine_version" {
  type        = string
  description = "The version number of the cache engine to be used for the cache clusters in this replication group."
}

variable "security_group_name" {
  type = string
}

variable "maintenance_window" {
  type        = string
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed."
}

variable "automatic_failover" {
  type        = bool
  description = "Automatic failover primary to replica. For single node set to false."
  default     = true
}