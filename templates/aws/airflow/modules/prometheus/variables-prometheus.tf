variable "prometheus_alias" {
  type        = string
  description = "Name of prometheus workspace."
}

variable "prometheus_log_group" {
  type        = string
  description = "Name of prometheus cloudwatch log group"
}

variable "prometheus_agent_roles" {
  type        = list(string)
  description = "List of agent prometheus roles that can remote write to central."
}