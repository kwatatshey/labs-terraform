variable "chart_name" {
  type        = string
  description = "Name of release"
  default     = "argo-rollouts"
}

variable "chart_version" {
  type        = string
  description = "Helm chart to release"
  default     = "2.35.1"
}

variable "repository" {
  type        = string
  description = "Repository to install the chart from"
  default     = "https://argoproj.github.io/argo-helm"
}

variable "customized_demo_enabled" {
  type = bool
  description = "Create your own customize rollouts demo"
  default = false
}

variable "traffic_light_demo_enabled" {
  type = bool
  description = "Create demo rollout"
  default = true
}

variable "namespace" {
  type        = string
  description = "Namespace name to deploy helm release"
}

variable "create_namespace" {
  type        = bool
  description = "Create the namespace if it does not exist"
  default     = true
}

variable "domain_name" {
  type        = string
  description = "Roure53 hosted zone name"
}

variable "dashboard_enabled" {
  type        = bool
  description = "Enable argo-rollouts web dashboard"
  default     = true
}