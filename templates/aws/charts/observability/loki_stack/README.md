## Commands
To get the password for Grafana dashboard admin run:
```bash
kubectl get secret --namespace loki-stack loki-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```


<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.loki_stack](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ACM Certificate ARN | `string` | n/a | yes |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart to release | `string` | `"2.9.11"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of EKS cluster | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Roure53 hosted zone name | `string` | n/a | yes |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Enable or not chart as a component | `bool` | `false` | no |
| <a name="input_extra_values"></a> [extra\_values](#input\_extra\_values) | Extra values in key value format | `map(any)` | `{}` | no |
| <a name="input_github_oauth_allowed_domains"></a> [github\_oauth\_allowed\_domains](#input\_github\_oauth\_allowed\_domains) | List of allowed domains for Github OAuth | `list(string)` | `[]` | no |
| <a name="input_github_oauth_allowed_organizations"></a> [github\_oauth\_allowed\_organizations](#input\_github\_oauth\_allowed\_organizations) | List of allowed organizations for Github OAuth | `list(string)` | `[]` | no |
| <a name="input_github_oauth_allowed_team_ids"></a> [github\_oauth\_allowed\_team\_ids](#input\_github\_oauth\_allowed\_team\_ids) | List of allowed teams for Github OAuth | `list(string)` | `[]` | no |
| <a name="input_github_oauth_client_id"></a> [github\_oauth\_client\_id](#input\_github\_oauth\_client\_id) | Github OAuth Client Id | `string` | `""` | no |
| <a name="input_github_oauth_client_secret"></a> [github\_oauth\_client\_secret](#input\_github\_oauth\_client\_secret) | Github OAuth Client Secret | `string` | `""` | no |
| <a name="input_github_oauth_enabled"></a> [github\_oauth\_enabled](#input\_github\_oauth\_enabled) | Enable or not Github OAuth | `bool` | `false` | no |
| <a name="input_ingress_enabled"></a> [ingress\_enabled](#input\_ingress\_enabled) | Enable or not ingress for loki stack | `bool` | `false` | no |
| <a name="input_loki_volume_size"></a> [loki\_volume\_size](#input\_loki\_volume\_size) | Size of EBS volume for loki | `string` | `"20Gi"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of release | `string` | `"loki-stack"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace name to deploy helm release | `string` | `"loki-stack"` | no |
| <a name="input_prometheus_alert_manager_volume_size"></a> [prometheus\_alert\_manager\_volume\_size](#input\_prometheus\_alert\_manager\_volume\_size) | Size of EBS volume for prometheus alert manager | `string` | `"5Gi"` | no |
| <a name="input_prometheus_server_volume_size"></a> [prometheus\_server\_volume\_size](#input\_prometheus\_server\_volume\_size) | Size of EBS volume for prometheus server | `string` | `"20Gi"` | no |
| <a name="input_serviceaccount"></a> [serviceaccount](#input\_serviceaccount) | Serviceaccount name | `string` | `"loki-stack"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->