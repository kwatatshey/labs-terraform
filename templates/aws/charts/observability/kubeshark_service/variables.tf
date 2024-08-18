variable "name" {
  description = "The name of the kubeshark"
  type        = string
}

variable "namespace" {
  description = "The namespace to deploy the kubeshark"
  type        = string
  default     = "kubeshark"
}

variable "kubeshark_helm_chart_version" {
  description = "The version of the kubeshark helm chart"
  type        = string
  default     = "52.1.77"
}

variable "domain_name" {
  description = "The domain name of the kubeshark"
  type        = string
}

variable "region" {
  description = "The region to deploy the kubeshark"
  type        = string
}

variable "scheme" {
  description = "The scheme of the kubeshark"
  type        = string
  default     = "internet-facing"
}

variable "acm_certificate_arn" {
  description = "The acm certificate arn of the kubeshark"
  type        = string
}