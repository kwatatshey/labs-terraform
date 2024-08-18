variable "name" {
  type        = string
  description = "Name of release"
  default     = "argocd"
}

variable "chart_name" {
  type        = string
  description = "Name of the chart to install"
  default     = "argo-cd"
}

variable "chart_version" {
  type        = string
  description = "Version of the chart to install"
  default     = "5.41.2"
}

variable "repository" {
  type        = string
  description = "Repository to install the chart from"
  default     = "https://argoproj.github.io/argo-helm"
}

variable "namespace" {
  type        = string
  description = "Namespace to install the chart into"
  default     = "argocd"
}

variable "serviceaccount" {
  type        = string
  description = "Serviceaccount name to install the chart into"
  default     = "argocd"
}

variable "extra_values" {
  type        = map(any)
  description = "Extra values in key value format"
  default     = {}
}

variable "create_namespace" {
  type        = bool
  description = "Create the namespace if it does not exist"
  default     = true
}

variable "recreate_pods" {
  type        = bool
  description = "Recreate pods in the deployment if necessary"
  default     = true
}

variable "timeout" {
  type        = number
  description = "Timeout for the helm release"
  default     = 3000
}

variable "hostname" {
  type        = string
  description = "Hostname of argocd"
}

# cert-manager certificate issuer
variable "certificate_issuer_name" {
  type        = string
  default = "letsencrypt-prod"
  description = "Name of cert-manager certificate issuer"
}

variable "configure_initial_gitops_repo" {
  type = bool
  default = false
  description = "Flag if needs to configure initial gitops repo"
}

variable "initial_gitops_repo_url" {
  type = string
  description = "Initial gitops repo url"
}

variable "initial_gitops_repo_username" {
  type = string
  description = "Username for initial gitops repo"
}

variable "initial_gitops_repo_password" {
  type = string
  description = "Password for initial gitops repo"
}

variable "oauth_enabled" {
  type        = bool
  description = "Enable OAuth login for ArgoCD"
  default     = false
}

variable "configure_sso" {
  type        = bool
  default = false
  description = "Flag if needs to configure SSO"  
}

variable "sso_provider" {
  type        = string
  description = "SSO provider. Possible values: google, github, gitlab, dex"
}

variable "sso_client_id" {
  type        = string
  description = "SSO client id"
}

variable "sso_org" {
  type        = string
  description = "SSO organization"
}
  
variable "admin_team_name" {
  type        = string
  description = "Name of admin team"
  default = "argocd-admins"
}
  
#Main project related variables
variable "main_project_name" {
  type = string
  description = "Name of main project"
  default = "main"
}

#Root application related variables
variable "create_root_app" {
  type = bool
  description = "Flag if needs to create root application"
  default = false
}

variable "root_app_name" {
  type = string
  description = "Name of root application"
  default = "root_app"
}
variable "root_app_target_revision" {
  type = string
  description = "Target revision of root application"
  default = "HEAD"
}

variable "root_app_path" {
  type = string
  description = "Path of root application"
  default = "apps"
}

variable "root_app_destination" {
  type = string
  description = "Destination of root application"
  default = "in-cluster"
} 

variable "root_app_dir_recurse" {
  type = bool
  description = "Flag if root application directory needs to be recursed"
  default = false
}        

variable "root_app_exclude" {
  type = string
  description = "List of root application directories to be excluded"
  default = ""
}

# TODO: OIDC login related variables
variable "oauth_client_secret_name" {
  type        = string
  default = ""
  description = "Name of AWS secret with OAuth client creds. See README for details"
}  
