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

variable "efs_throughput_mode" {
  type        = string
  description = "Throughput mode of EFS drive. bursting or elastic"
}

variable "rds_parameter_group_family" {
  type        = string
  description = "Parameter group family"
}

variable "rds_parameters" {
  description = "A list of DB parameters (map) to apply"
  type        = list(map(string))
}

variable "coredns_replicas" {
  type        = number
  description = "Number of coredns pod replicas"
}