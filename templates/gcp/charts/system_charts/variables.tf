//Global vars
variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
  default = "Default value for AWS - to make this param Optional"
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
  default = "Default value for GCP - to make this param Optional"
}

//External DNS vars
variable "gke_external_dns_enabled" {
  description = "Whether to install external-dns for gke"
  type        = bool
  default = false
}
  
variable "external_dns_namespace" {
  description = "The namespace to install external-dns"
  type        = string
  default = "external-dns"
}

variable "external_dns_chart_name" {
  description = "The chart name to install external-dns"
  type        = string
  default = "external-dns"
}
variable "external_dns_chart_version" {
  description = "The chart version to install external-dns"
  type        = string
  default = "1.12.0"
}  

variable "external_dns_service_account_name" {
  description = "The service account name to install external-dns"
  type        = string
  default = "external-dns"
}

variable "external_dns_domain_filter" {
  description = "The domain filter to install external-dns"
  type        = string
  default = "Just a place holder to make this param Optional"
}
  
variable "external_dns_extra_values" {
  description = "Extra values to pass to the chart"
  type        = map(string)
  default = {}  
}
  
//Cert Manager vars
variable "cert_manager_enabled" {
  description = "Whether to install cert-manager"
  type        = bool
  default = false
}

variable "cert_manager_namespace" {
  description = "The namespace to install cert-manager"
  type        = string
  default = "cert-manager"
}

variable "cert_manager_helm_chart_version" {
  description = "The chart version to install cert-manager"
  type        = string
  default = "v1.11.0"
}
  
variable "cert_manager_issuer_staging_mode" {
  description = "Whether to install cert-manager in staging mode"
  type        = bool
  default = true
}

variable "cert_manager_issuer_email" {
  description = "The email to use for the cert-manager issuer"
  type        = string
  default = ""
}

//Kong vars
variable "kong_enabled" {
  description = "Whether to install kong"
  type        = bool
  default = false
}

variable "kong_namespace" {
  description = "The namespace to install kong"
  type        = string
  default = "kong"
}

variable "kong_version" {
  description = "The version to install kong"
  type        = string
  default = "2.26.3"
}

variable "kong_extra_values" {
  description = "Extra values to pass to the chart"
  type        = map(string)
  default = {}  
}
