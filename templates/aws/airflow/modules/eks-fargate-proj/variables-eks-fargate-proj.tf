variable "cluster_name" {
  type        = string
  description = "Name of EKS cluster"
}

variable "profile_name" {
  type        = string
  description = "Name of Fargate profile"
}

variable "fargate_role_name" {
  type        = string
  description = "Name of fargate role"
}

variable "subnet_ids" {
  type        = list(any)
  description = "List of subnet IDs that pods in this Fargate profile will be deployed in"
}

variable "namespace" {
  type        = string
  description = "Namespace of projects airflow components"
}
