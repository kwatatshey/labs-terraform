variable "name" {
  type        = string
  description = "Name of release"
  default     = "alb-controller"
}

variable "namespace" {
  type        = string
  description = "Namespace name to deploy helm release"
  default     = "kube-system"
}

variable "chart_version" {
  type        = string
  description = "Helm chart to release"
  default     = "1.6.1"
}

variable "create_role_enabled" {
  type        = bool
  description = "Enable or not chart as a component"
  default     = false
}

variable "serviceaccount" {
  type        = string
  description = "Serviceaccount name"
  default     = "alb-controller"
}

variable "region" {
  type        = string
  description = "AWS region where the ASG placed"
}

variable "cluster_name" {
  type        = string
  description = "Name of EKS cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the cluster is deployed"
}

variable "cluster_oidc_provider_arn" {
  type        = string
  description = "EKS cluster OIDC provider ARN"
}
