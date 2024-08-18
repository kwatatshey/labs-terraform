variable "namespace" {
  default = "keda"
  type    = string
}

variable "chart_name" {
  default = "keda"
  type    = string
}

variable "repository" {
  default     = "https://kedacore.github.io/charts"
  description = "Keda Chart Repository"
}

variable "chart_version" {
  default     = "2.14.3"
  description = "The Keda helm chart version"
}

variable "sqs_policy_actions" {
  default     = ["sqs:SendMessage"]
  description = "Permissions to attach to the SQS Policy"
}
variable "cluster_oidc_provider_arn" {
  description = "The Cluster oidc provider"
}

variable "keda_poc_enabled" {
  default     = false
  description = "To enable the keda poc or just install the keda operator"
}

variable "region" {
  default = "eu-west-1"
}
