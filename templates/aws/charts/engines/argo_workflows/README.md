<h1 align="center">Argo Events & Argo Workflows</h1>

<p align="center">
  <img src="https://github.com/Opsfleet/labs-terraform/assets/10208228/0ff95005-a3ad-4a79-8725-65a8e6e06f6b" width="450"/>
</p>

# General
## &nbsp;&nbsp; Documentation
### &nbsp;&nbsp; <ins>Argo Events</ins>
  
  | Name | Link |
  |------|------|
  | Git Repository | https://github.com/argoproj/argo-events |
  | Helm Chart Versions | https://github.com/argoproj/argo-helm/pkgs/container/argo-helm%2Fargo-events |

  ---
  
### &nbsp;&nbsp; <ins>Argo Workflows</ins>
  
  | Name | Link |
  |------|------|
  | Git Repository | https://github.com/argoproj/argo-workflows |
  | Helm Chart Versions | https://github.com/argoproj/argo-helm/pkgs/container/argo-helm%2Fargo-workflows |  

---

# Terraform

## &nbsp;&nbsp; Requirements

  | Name | Version |
  |------|---------|
  | <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
  | <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.1 |

## &nbsp;&nbsp; Providers

  | Name | Version |
  |------|---------|
  | <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.12.1 |

## &nbsp;&nbsp; Inputs

  | Name | Description | Type | Default | Required |
  |------|:-----------:|:----:|:-------:|:--------:|
  | <a name="input_argo_events_chart_name"></a> [argo\_events\_chart\_name](#input\_argo\_events\_chart\_name) | Name of chart | `string` | `"argo-events"` | no |
  | <a name="input_argo_events_chart_version"></a> [argo\_events\_chart\_version](#input\_argo\_events\_chart\_version) | Version of argo-events chart | `string` | `"2.4.4"` | no |
  | <a name="input_argo_workflows_chart_name"></a> [argo\_workflows\_chart\_name](#input\_argo\_workflows\_chart\_name) | Name of chart | `string` | `"argo-workflows"` | no |
  | <a name="input_argo_workflows_chart_version"></a> [argo\_workflows\_chart\_version](#input\_argo\_workflows\_chart\_version) | Version of argo-workflows chart | `string` | `"0.41.0"` | no |
  | <a name="input_argocd_github_sso_secret"></a> [argocd\_github\_sso\_secret](#input\_argocd\_github\_sso\_secret) | Name of secret contains GitHub app credentials | `string` | n/a | yes |
  | <a name="input_argocd_hostname"></a> [argocd\_hostname](#input\_argocd\_hostname) | Argocd host name | `string` | n/a | yes |
  | <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create the namespace if it does not exist | `bool` | `true` | no |
  | <a name="input_hostname"></a> [hostname](#input\_hostname) | Argo-Workflows hostname | `string` | n/a | yes |
  | <a name="input_namespace"></a> [namespace](#input\_namespace) | Argo-Workflows namespace | `string` | n/a | yes |
  | <a name="input_repository"></a> [repository](#input\_repository) | Repository to install the chart from | `string` | `"https://argoproj.github.io/argo-helm"` | no |
  | <a name="input_sso_enabled"></a> [sso\_enabled](#input\_sso\_enabled) | Single sign-on (SSO) authentication for argo-workflows | `string` | n/a | yes |

---

# Terragrunt

## &nbsp;&nbsp; Configuration File
  
  | Name | Link |
  |------|------|
  | <a name="link_terragrunt.hcl"></a> [terragrunt.hcl](#link\_terragrunt.hcl) | https://github.com/Opsfleet/labs-terraform/blob/main/labs/dev/aws/sandbox/eu-west-1/infra-01/app_cluster/030_engines/terragrunt.hcl |

## &nbsp;&nbsp; Parameters

  | Name | Description | Type | Default | Condition |
  |------|:-----------:|:----:|:-------:|:---------:|
  | <a name="input_argo_workflows_enabled"></a> [argo\_workflows\_enabled](#input\_argo\_workflows\_enabled) | Deploy Argo Events & Argo-workflows Helm charts | `bool` | `false` | `-` |
  | <a name="input_argo_workflows_sso_enabled"></a> [argo\_workflows\_sso\_enabled](#input\_argo\_workflows\_sso\_enabled) | Enable GitHub SSO using ArgoCD Dex server | `bool` | `false` | `argocd_enabled=true`<br>and<br> `argocd_sso_enabled=true`|
  | <a name="input_argo_workflows_namespace"></a> [argo\_workflows\_namespace](#input\_argo\_workflows\_namespace) | The namespace where Argo-Workflows resources will be deployed | `string` | `argo-workflows` | `-` |

  ---
## Have Fun 😃
