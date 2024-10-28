# Pull info about security group to be attached to Redis cluster
data "aws_security_group" "redis_sg" {
  name = var.security_group_name

}

# Create elasticache Redis cluster 
resource "aws_elasticache_replication_group" "redisQ" {

  auth_token                 = var.auth_token
  replication_group_id       = var.replication_group_id
  description                = "Redis to be used as celery broker by Airflow on EKS"
  multi_az_enabled           = var.multi_az_enabled
  node_type                  = var.node_type
  num_cache_clusters         = var.num_cache_clusters
  port                       = var.port
  parameter_group_name       = var.parameter_group
  automatic_failover_enabled = var.automatic_failover
  auto_minor_version_upgrade = true
  subnet_group_name          = var.subnet_group_name
  engine_version             = var.engine_version
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  security_group_ids         = [data.aws_security_group.redis_sg.id]
  maintenance_window         = var.maintenance_window
  snapshot_retention_limit   = 1
  apply_immediately          = true

}

# Output Redis master endpoint hostname
output "redis_host" {
  value       = aws_elasticache_replication_group.redisQ.primary_endpoint_address
  description = "Hostname of Redis instance"
}
