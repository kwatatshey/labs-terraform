variable "project_prefix" {
  type        = string
  description = "AWS account prefix to be used for the given project."
}

variable "project_id" {
  type        = string
  description = "ID that will uniquely identify given project instance  "
}

variable "environment" {
  type        = string
  description = "Environment of deployment. dev/test/uat/prod"
}

variable "backup_region" {
  type        = string
  description = "Region to for duplication of secrets or rds snapshot for DR purposes"
}

variable "fernet_key" {
  type        = string
  description = "Fernet key value"
  sensitive   = true
}

variable "metadata_store_postgres_host" {
  type        = string
  description = "Hostname of RDS DB"
}

variable "metadata_store_postgres_port" {
  type        = string
  description = "Port of RDS DB"
}

variable "redis_host" {
  type        = string
  description = "Hostname of Redis"
}

variable "redis_auth_token" {
  type        = string
  description = "Redis AUTH token value"
  sensitive   = true
}

variable "webserver_secret" {
  type        = string
  description = "User and password to access flower UI"
  sensitive   = true
}

variable "flower_ui_access" {
  type        = string
  description = "User and password to access flower UI"
  sensitive   = true
}

variable "ldap_password" {
  type        = string
  description = "Password to integrate with LDAP"
  sensitive   = true
}

variable "git_sync_github_user" {
  type        = string
  description = "Github user for gitsync"
  sensitive   = true
}

variable "git_sync_github_pat" {
  type        = string
  description = "Github PAT for gitsync"
  sensitive   = true
}

variable "airflow_password" {
  type        = string
  description = "Password for airflow user"
  sensitive   = true
}

variable "airflow_read_password" {
  type        = string
  description = "Password for airflow read user"
  sensitive   = true
}

variable "postgres_master_password" {
  type        = string
  description = "Password for postgres master user"
  sensitive   = true
}
