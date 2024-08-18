variable "enabled" {
  type        = bool
  default     = false
  description = "Variable indicating whether Cert Manager deployment is enabled."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment name"
}

variable "cert_manager_helm_chart_version" {
  type        = string
  default     = "1.11.0"
  description = "Cert Manager Helm chart version."
}

variable "github_token" {
  type        = string
  description = "GitHub PAT token"
  default     = ""
}

variable "token_ssm_parameter" {
  type    = string
  default = ""
}

variable "serviceaccount" {
  type        = string
  description = "Serviceaccount for Github runners"
  default     = "actions-runner-system"
}

variable "cluster_oidc_provider_arn" {
  type        = string
  description = "EKS cluster OIDC provider ARN"
}

variable "webhook_server_enabled" {
  type    = bool
  default = false
}

variable "webhook_server_host" {
  type    = string
  default = ""
}

variable "webhook_server_path" {
  type    = string
  default = "/"
}

variable "webhook_server_secret_enabled" {
  type    = bool
  default = false
}

variable "runnerGithubURL" {
  type    = string
  default = ""
}

variable "namespace" {
  type    = string
  default = "actions-runner-system"
}

variable "github_helm_charts_s3_bucket" {
  type        = string
  description = "S3 bucket name to keep Helm charts"
  default     = ""
}

variable "ssm_prefix" {
  type        = string
  description = "SSM Path to Github tokens"
  default     = "/github"
}

variable "runners_deploy_list" {
  type = list(object({
    name          = optional(string)
    repository    = optional(string)
    limits_cpu    = optional(string)
    limits_memory = optional(string)
    replicas_min  = optional(number)
    replicas_max  = optional(number)
  }))
  default = []
}
