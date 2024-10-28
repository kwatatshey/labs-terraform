variable "eks_cluster_role_arn" {
  type        = string
  description = "ARN of role that will be used by EKS cluster"
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of EKS cluster"
}

variable "subnet_ids" {
  type        = list(any)
  description = "List of subnet IDs that the EKS cluster will be deployed in"
}

variable "security_group_names" {
  type        = list(string)
  description = "Security groups that will attached to the cluster"
}

variable "enabled_cluster_log_types" {
  type        = list(string)
  description = "A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`]"
}

variable "kubernetes_version" {
  type        = string
  description = "Version of kubernetes"
}

variable "eks_kms_alias" {
  type        = string
  description = "Alias for KMS key"
}