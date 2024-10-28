variable "project_prefix" {
  type        = string
  description = "AWS account prefix to be used for the given project."
}

variable "aws_account_number" {
  type        = string
  description = "AWS account number. 12 digits."
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "eks_oidc_url" {
  type        = string
  description = "OIDC URL of EKS cluster"
}

variable "eks_pod_role_name" {
  type        = string
  description = "Eks pod role name"
  default     = null
}

variable "eks_external_dns_role_name" {
  type        = string
  description = "Eks external dns role name"
  default     = null
}

variable "eks_alb_role_name" {
  type        = string
  description = "Eks alb role name"
  default     = null
}

variable "eks_pod_policy_name" {
  type        = string
  description = "Eks pod policy name"
  default     = null
}

variable "eks_external_dns_policy_name" {
  type        = string
  description = "Eks external dns policy name"
  default     = null
}

variable "eks_alb_policy_name" {
  type        = string
  description = "Eks alb policy name"
  default     = null
}

variable "eks_pod_policy_description" {
  type        = string
  description = "Eks pod policy desc"
  default     = "Policy to be used by Airflow EKS pods role to access AWS resources."
}

variable "eks_alb_policy_description" {
  type        = string
  description = "Eks alb policy desc"
  default     = "Policy to be used by a Airflow EKS Load balancer controller role to manage provisioning of load balancers for EKS cluster."
}