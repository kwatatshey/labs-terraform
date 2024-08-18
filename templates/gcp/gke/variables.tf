variable "gke_count" {
  description = "Set to 1 if we wish to enable GKE, 0 otherwise"
  type        = number
  default = 1
}
  
variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}
  
variable "network_name" {
  description = "The name of the VPC network to create"
  type        = string
  default = "wf-dev"
}

# OPTIONAL -  needed only for regional clusters
variable "region" {
  description = "The region to host the cluster in"
  type        = string
  default = "us-central1"
}

variable "zones" {
  description = "The zones to host the cluster in"
  type        = list(string)
  default = ["us-central1-a"]
}

variable "subnetwork" {
  description = "The name of the subnetwork to create"
  type        = string
  default = "wf-dev-subnet-01"
}
variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default = "wf-1"
}

variable "ip_range_pods" {
  description = "The secondary ip range to use for pods"
  type        = string
  default = "wf-dev-subnet-01-secondary-pods-01"
}

variable "ip_range_services" {
  description = "The secondary ip range to use for services"
  type        = string
  default = "wf-dev-subnet-01-secondary-services-02"
}

variable "regional" {
  description = "Whether the cluster is regional"
  type        = bool
  default = false
}

variable "remove_default_node_pool" {
  description = "Whether the default node pool should be removed"
  type        = bool
  default = true
}
variable "cluster_parent_hosted_zone" {
  description = "The parent hosted zone of the cluster -  the . char will be added in the code"
  type        = string
  default = "dev.assafushy.com"
}
  
  
//Charts Vars

//External DNS vars
variable "external_dns_enabled" {
  description = "Whether to install external-dns"
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
  default = "dev.assafushy.com"
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
  
