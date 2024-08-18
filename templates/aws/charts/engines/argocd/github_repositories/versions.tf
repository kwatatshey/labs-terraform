terraform {
  required_version = ">= 0.13"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}
