variable "cluster_name" {
  type        = string
  description = "Name of EKS cluster"
}

variable "vpc_cni_addon_version" {
  type        = string
  description = "Vpc cni addon version"
}

variable "coredns_addon_version" {
  type        = string
  description = "coredns addon version"
}

variable "kube_proxy_addon_version" {
  type        = string
  description = "kube proxy addon version"
}

variable "profile_name" {
  type        = string
  description = "Name of Fargate profile"
}

variable "fargate_role_arn" {
  type        = string
  description = "ARN of fargate role"
}

variable "subnet_ids" {
  type        = list(any)
  description = "List of subnet IDs that pods in this Fargate profile will be deployed in"
}

variable "coredns_replicas" {
  type        = number
  description = "Number of coredns pod replicas"
  default     = 2
}