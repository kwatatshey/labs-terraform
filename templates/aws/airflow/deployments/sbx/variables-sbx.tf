variable "common_tags" {
  description = "Common tags to be assigned across infrastructure pieces"
  type        = map(string)
}

variable "project_prefix" {
  type        = string
  description = "AWS account prefix to be used for the given project."
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "aws_account_number" {
  type        = string
  description = "AWS account number. 12 digits."
}

variable "vpc_cni_addon_version" {
  type        = string
  description = "vpc cni addon eks version"
}

variable "coredns_addon_version" {
  type        = string
  description = "coredns addon eks version"
}

variable "kube_proxy_addon_version" {
  type        = string
  description = "kube proxy addon eks version"
}

variable "environment" {
  type        = string
  description = "Environment of deployment. dev/test/uat/prod"
}

variable "target_vpc_id" {
  type        = string
  description = "ID of target VPC"
}

variable "routable_subnets" {
  type        = list(any)
  description = "List of subnet IDs that the EKS cluster will be deployed in"
}

variable "cluster_security_groups_names" {
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

variable "non_routable_subnets" {
  type        = list(any)
  description = "List of subnet IDs that the k8s pods will be deployed in. Merck non routables"
}


variable "rds_parameter_group_family" {
  type        = string
  description = "Parameter group family"
}

variable "rds_parameters" {
  description = "A list of DB parameters (map) to apply"
  type        = list(map(string))
}

variable "rds_allocated_storage" {
  type = number
}

variable "rds_engine_version" {
  type = string
}

variable "rds_instance_class" {
  type = string
}

variable "rds_vpc_security_group_names" {
  type = list(string)
}

variable "rds_port" {
  type = number
}

variable "rds_storage_type" {
  type = string
}

variable "rds_backup_retention_period" {
  type = number
}

variable "rds_delete_protection" {
  type = bool
}

variable "rds_replica_kms_key_name" {
  type = string
}

variable "rds_maintenance_window" {
  type = string
}

variable "rds_backup_window" {
  type = string
}

variable "backup_region" {
  type        = string
  description = "Region to for duplication of secrets or rds snapshot for DR purposes"
}

variable "secretsmanager_sandbox_secrets_name" {
  type        = string
  description = "Name of secret with common secrets"
}
