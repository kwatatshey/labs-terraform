variable "namespace" {
  type        = string
  description = "Argo-Workflows namespace"
}

variable "create_namespace" {
  type        = bool
  description = "Create the namespace if it does not exist"
  default     = true
}

variable "repository" {
  type        = string
  description = "Repository to install the chart from"
  default     = "https://argoproj.github.io/argo-helm"
}

variable "argo_events_chart_name" {
  type        = string
  description = "Name of chart"
  default     = "argo-events"
}

variable "argo_workflows_chart_name" {
  type        = string
  description = "Name of chart"
  default     = "argo-workflows"
}

variable argo_events_chart_version {
  type        = string
  default     = "2.4.4"
  description = "Version of argo-events chart"
}

variable argo_workflows_chart_version {
  type        = string
  default     = "0.41.0"
  description = "Version of argo-workflows chart"
}

variable hostname {
  type        = string
  description = "Argo-Workflows hostname"
}

variable sso_enabled {
  type        = string
  description = "Single sign-on (SSO) authentication for argo-workflows"
}

variable "argocd_hostname" {
  type        = string
  description = "Argocd host name"
}

variable "argocd_github_sso_secret" {
  type        = string
  description = "Name of secret contains GitHub app credentials"
}