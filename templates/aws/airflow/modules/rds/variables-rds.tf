variable "identifier" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
}

variable "parameter_group_name" {
  type = string
}

variable "db_subnet_group_name" {
  type = string
}

variable "security_group_names" {
  type = list(string)
}

variable "port" {
  type = number
}

variable "final_snapshot_identifier" {
  type = string
}

variable "storage_type" {
  type = string
}

variable "backup_retention_period" {
  type = number
}

variable "delete_protection" {
  type = bool
}

variable "replica_kms_key_name" {
  type = string
}

variable "maintenance_window" {
  type = string
}

variable "backup_window" {
  type = string
}

variable "airflow_password" {
  type      = string
  sensitive = true
}

variable "airflow_read_password" {
  type      = string
  sensitive = true
}
