variable "efs_name" {
  type        = string
  description = "Name of EFS drive"
}

variable "creation_token" {
  type        = string
  description = "Name of creation token"
  default     = null
}

variable "efs_throughput_mode" {
  type        = string
  description = "Throughput mode of EFS drive. bursting or elastic"
}

variable "efs_mount_targets_subnets" {
  type        = list(any)
  description = "List of subnets for EFS drive mount targets"
}

variable "efs_mount_targets_sg" {
  type        = list(string)
  description = "List of security groups for EFS drive mount targets"
}

variable "efs_ap_name" {
  type        = string
  description = "Name of access point"
}
