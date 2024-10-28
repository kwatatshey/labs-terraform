variable "project_prefix" {
  type        = string
  description = "AWS account prefix to be used for the given project."
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "eks_cluster_role_name" {
  type        = string
  description = "Cluster role name"
  default     = null
}

variable "eks_fargate_role_name" {
  type        = string
  description = "Fargate role name"
  default     = null
}

variable "eks_fargate_logging_policy_name" {
  type        = string
  description = "Fargate logging policy name"
  default     = null
}

variable "eks_fargate_logging_policy_description" {
  type        = string
  description = "Fargate logging policy desc"
  default     = "Policy to allow fargate to send logs to CloudWatch"
}