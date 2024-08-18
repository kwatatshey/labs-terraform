# Common
variable "cluster_oidc_provider_arn" {
  description = "The OIDC provider ARN for the EKS cluster"
  type        = string
  default     = "arn:aws:iam::account-id:oidc-provider/oidc.eks.region.amazonaws.com/id"
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to host the cluster in"
  type        = string
}

variable "domain_name" {
  type        = string
  description = "The domain filter to install external-dns"
}

variable "acm_certificate_arn" {
  type = string
}

variable "cluster_endpoint" {
  type        = string
  description = "EKS cluster endpoint"
}

# Cluster autoscaler
variable "cluster_autoscaler_enabled" {
  type    = bool
  default = false
}
variable "cluster_autoscaler_namespace" {
  type    = string
  default = "kube-system"
}

# Karpenter
variable "karpenter_enabled" {
  type        = bool
  default     = false
  description = "Whether to install karpenter"
}
variable "karpenter_namespace" {
  type    = string
  default = "kube-system"
}

# AWS LB Controller
variable "alb_controller_enabled" {
  type    = bool
  default = false
}
variable "alb_controller_namespace" {
  type    = string
  default = "kube-system"
}

## Kong
variable "kong_enabled" {
  description = "Whether to install kong"
  type        = bool
  default     = false
}
variable "kong_namespace" {
  description = "The namespace to install kong"
  type        = string
  default     = "kong"
}

## External DNS
variable "eks_external_dns_enabled" {
  description = "Whether to install external-dns for eks"
  type        = bool
  default     = false
}
variable "external_dns_namespace" {
  description = "The namespace to install external-dns"
  type        = string
  default     = "external-dns"
}

# Cert Manager
variable "cert_manager_enabled" {
  description = "Whether to install cert-manager"
  type        = bool
  default     = false
}
variable "cert_manager_namespace" {
  description = "The namespace to install cert-manager"
  type        = string
  default     = "cert-manager"
}

# External Secrets
variable "external_secrets_enabled" {
  type    = bool
  default = false
}
variable "external_secrets_namespace" {
  type        = string
  description = "Namespace name to deploy helm release"
  default     = "kube-system"
}
variable "external_secrets_regex" {
  type        = string
  description = "AWS SM Secrets regex for ARN"
  default     = "*"
}

# EBS CSI Driver
variable "ebs_csi_enabled" {
  type    = bool
  default = false
}
variable "ebs_csi_driver_namespace" {
  type        = string
  description = "Namespace name to deploy helm release"
  default     = "kube-system"
}

# Metrics Server
variable "metrics_server_enabled" {
  type    = bool
  default = false
}
variable "metrics_server_namespace" {
  type        = string
  description = "Namespace name to deploy helm release"
  default     = "kube-system"
}

# AWS node termination handler
variable "aws_node_termination_handler_enabled" {
  type    = bool
  default = false
}
variable "aws_node_termination_handler_namespace" {
  type    = string
  default = "kube-system"
}

# Keda
variable "keda_enabled" {
  default = false
  type    = bool
}
variable "keda_poc_enabled" {
  default = false
  type    = bool
}
variable "keda_namespace" {
  type        = string
  description = "Namespace name to deploy helm release"
  default     = "keda"
}
