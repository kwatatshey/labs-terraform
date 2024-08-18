variable "release_name" {
  type        = string
  description = "Name of release"
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

variable "app_selector_label" {
  type    = string
  default = "rollouts-demo"
}

variable "traffic_light_demo_enabled" {
  type = bool
  description = "Create traffic_light rollout demo"
  default = false
}