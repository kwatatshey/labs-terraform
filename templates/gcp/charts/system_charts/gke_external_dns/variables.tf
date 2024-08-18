variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
}
    
variable "namespace" {
  description = "The namespace to install the chart"
  type        = string
  default = "kube-system"
}

variable "name" {
  description = "The name of the chart"
  type        = string
  default = "external-dns"
}

variable "external_dns_version" {
  description = "The version of the chart"
  type        = string
  default = "1.12.0"
}

variable "serviceaccount" {
  description = "The service account to use for the chart"
  type        = string
  default = "external-dns"
}

variable "domain_name" {
  description = "The domain name to use for the chart"
  type        = string
}
variable "extra_values" {
  description = "Extra values to pass to the chart"
  type        = map(string)
  default = {}  
}
