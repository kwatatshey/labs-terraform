variable "rds_subnet_group_name" {
  type        = string
  description = "Name RDS subnet group"
}

variable "rds_subnets" {
  type        = list(any)
  description = "List of subnets for RDS"
}

variable "rds_parameter_group_name" {
  type        = string
  description = "Name RDS parameter group"
}

variable "rds_parameter_group_description" {
  type        = string
  description = "Name RDS parameter group"
  default     = "Airflow EKS - parameter group with custom password encryption MD5 and max connections"
}

variable "rds_parameter_group_family" {
  type        = string
  description = "Parameter group family"
}

variable "rds_parameters" {
  description = "A list of DB parameters (map) to apply"
  type        = list(map(string))
}
