#Common vars

variable "cluster_name" {
  type        = string
  description = "Name of K8S cluster"
}

variable "repository" {
  type        = string
  description = "All Argo project Repository to install the chart from"
  default     = "https://argoproj.github.io/argo-helm"
}

# cert-manager certificate issuer
variable "certificate_issuer_name" {
  type        = string
  default = "letsencrypt-prod"
  description = "Name of cert-manager certificate issuer"
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
  default     = 1200
}

#ArgoCD vars

variable "argocd_release_name" {
  type        = string
  description = "Name of release"
  default     = "argocd"
}

variable "argocd_enabled" {
  type    = bool
  default = false
}

variable "argocd_chart_name" {
  type        = string
  description = "Name of the chart to install"
  default     = "argo-cd"
}

variable "argocd_chart_version" {
  type        = string
  description = "Version of the chart to install"
  default     = "5.41.2"
}

variable "argocd_namespace" {
  type        = string
  description = "Namespace to install the chart into"
  default     = "argocd"
}

variable "argocd_serviceaccount" {
  type        = string
  description = "Serviceaccount name to install the chart into"
  default     = "argocd"
}

variable "argocd_extra_values" {
  type        = map(any)
  description = "Extra values in key value format"
  default     = {}
}

variable "argocd_hostname" {
  type        = string
  description = "Hostname of argocd"
}

variable "argocd_configure_initial_gitops_repo" {
  type = bool
  default = false
  description = "Configure initial gitops repo"
}

variable "argocd_initial_gitops_repo_url" {
  type = string
  description = "Initial gitops repo url"
}

variable "argocd_initial_gitops_repo_username" {
  type = string
  description = "value of username for initial gitops repo"
}

variable "argocd_initial_gitops_repo_password" {
  type = string
  description = "value of password for initial gitops repo"
}

variable "argocd_configure_sso" {
  type        = bool
  default = false
  description = "Flag if needs to configure SSO"  
}

variable "argocd_sso_provider" {
  type        = string
  description = "SSO provider. Possible values: google, github, gitlab, dex"
}

variable "argocd_sso_client_id" {
  type        = string
  description = "SSO client id"
}

variable "argocd_sso_org" {
  type        = string
  description = "SSO organization"
}
  
variable "argocd_admin_team_name" {
  type        = string
  description = "Name of admin team"
  default = "argocd-admins"
}
#Main project related variables
variable "argocd_main_project_name" {
  type = string
  description = "Name of main project"
  default = "main"
}

#Root application related variables
variable "argocd_create_root_app" {
  type = bool
  description = "Flag if needs to create root application"
  default = false
}

variable "argocd_root_app_name" {
  type = string
  description = "Name of root application"
  default = "root_app"
}

variable "argocd_root_app_target_revision" {
  type = string
  description = "Target revision of root application"
  default = "HEAD"
}

variable "argocd_root_app_path" {
  type = string
  description = "Path of root application"
  default = "apps"
}

variable "argocd_root_app_destination" {
  type = string
  description = "Destination of root application"
  default = "in-cluster"
} 

variable "argocd_root_app_dir_recurse" {
  type = bool
  description = "Flag if root application directory needs to be recursed"
  default = false
}        

variable "argocd_root_app_exclude" {
  type = string
  description = "List of root application directories to be excluded"
  default = ""
}


# # TODO OIDC login related variables
# variable "oauth_client_secret_name" {
#   type        = string
#   default = ""
#   description = "Name of AWS secret with OAuth client creds. See README for details"
# }

