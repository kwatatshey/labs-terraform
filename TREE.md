```
/github/workspace
|-- Makefile
|-- README.md
|-- TREE.md
|-- cf.yml
|-- graph.svg
|-- graph_curl.svg
|-- graph_rect.svg
|-- labs
|   |-- Infrastructure
|   |   `-- eu-west-1
|   |       `-- region_specific.hcl
|   |-- dev
|   |   |-- aws
|   |   |   |-- cloud.hcl
|   |   |   |-- sbx
|   |   |   |   |-- account.hcl
|   |   |   |   `-- eu-west-1
|   |   |   `-- terragrunt-full-graph.dot
|   |   |-- env.hcl
|   |   `-- gcp
|   |       |-- README.md
|   |       |-- cloud_specific.hcl
|   |       `-- opsfleet-development
|   |           |-- account_specific.hcl
|   |           `-- us-central1
|   |-- org.hcl
|   `-- production
|       `-- eu-west-1
|           |-- infra
|           |   |-- eks
|           |   |-- environment_specific.hcl
|           |   `-- vpc-private-public
|           `-- region_specific.hcl
|-- templates
|   |-- aws
|   |   |-- airflow
|   |   |   |-- README.md
|   |   |   |-- cloudbees
|   |   |   |   |-- access-management
|   |   |   |   |-- config
|   |   |   |   `-- scripts
|   |   |   |-- deployments
|   |   |   |   |-- dev
|   |   |   |   |-- monitoring
|   |   |   |   |-- prod
|   |   |   |   |-- sbx
|   |   |   |   |-- sit
|   |   |   |   `-- uat
|   |   |   |-- modules
|   |   |   |   |-- efs
|   |   |   |   |-- efs-proj
|   |   |   |   |-- eks
|   |   |   |   |-- eks-fargate-infra
|   |   |   |   |-- eks-fargate-proj
|   |   |   |   |-- iam-eks-srv
|   |   |   |   |-- iam-irsa
|   |   |   |   |-- lambda
|   |   |   |   |-- oidc
|   |   |   |   |-- prometheus
|   |   |   |   |-- rds
|   |   |   |   |-- rds-sbx
|   |   |   |   |-- rds-support
|   |   |   |   |-- redis
|   |   |   |   |-- redis-support
|   |   |   |   |-- route53
|   |   |   |   |-- s3
|   |   |   |   |-- secretsmanager
|   |   |   |   `-- sns
|   |   |   |-- scripts
|   |   |   |   |-- create_airflow_read_user.sql
|   |   |   |   |-- create_airflow_user.sql
|   |   |   |   |-- create_airflow_user_sbx.sql
|   |   |   |   `-- grant_airflow_read_access.sql
|   |   |   `-- templates
|   |   |       |-- cloudbees
|   |   |       `-- manual
|   |   |-- charts
|   |   |   |-- engines
|   |   |   |   |-- alb_controller
|   |   |   |   |-- apache_airflow
|   |   |   |   |-- argo_rollouts
|   |   |   |   |-- argo_workflows
|   |   |   |   |-- argocd
|   |   |   |   |-- github_runners
|   |   |   |   |-- jenkins_server
|   |   |   |   |-- locals.tf
|   |   |   |   |-- main.tf
|   |   |   |   |-- outputs.tf
|   |   |   |   |-- variables.tf
|   |   |   |   `-- versions.tf
|   |   |   |-- observability
|   |   |   |   |-- jaeger_service
|   |   |   |   |-- kubeshark_service
|   |   |   |   |-- loki_stack
|   |   |   |   |-- main.tf
|   |   |   |   |-- outputs.tf
|   |   |   |   |-- variables.tf
|   |   |   |   `-- versions.tf
|   |   |   |-- system_charts
|   |   |   |   |-- alb_controller
|   |   |   |   |-- aws_node_termination_handler
|   |   |   |   |-- certificate_manager
|   |   |   |   |-- cluster_autoscaler
|   |   |   |   |-- ebs_csi
|   |   |   |   |-- eks_external_dns
|   |   |   |   |-- external_secrets
|   |   |   |   |-- karpenter
|   |   |   |   |-- keda_operator
|   |   |   |   |-- kong_ingress_controller
|   |   |   |   |-- main.tf
|   |   |   |   |-- metrics_server
|   |   |   |   |-- outputs.tf
|   |   |   |   |-- variables.tf
|   |   |   |   `-- versions.tf
|   |   |   `-- system_configurations
|   |   |       |-- cert_manager_issuers
|   |   |       |-- main.tf
|   |   |       |-- outputs.tf
|   |   |       `-- variables.tf
|   |   |-- ecr
|   |   |   |-- locals.tf
|   |   |   |-- main.tf
|   |   |   |-- outputs.tf
|   |   |   `-- variables.tf
|   |   |-- eks
|   |   |   |-- access.tf
|   |   |   |-- acm.tf
|   |   |   |-- add_sg
|   |   |   |   |-- main.tf
|   |   |   |   |-- outputs.tf
|   |   |   |   `-- variables.tf
|   |   |   |-- add_sg.tf
|   |   |   |-- addons.tf
|   |   |   |-- data.tf
|   |   |   |-- eks.tf
|   |   |   |-- fargate
|   |   |   |   |-- main.tf
|   |   |   |   `-- variables.tf
|   |   |   |-- fargate.tf
|   |   |   |-- kms.tf
|   |   |   |-- locals.tf
|   |   |   |-- nodegroups.tf
|   |   |   |-- nodes
|   |   |   |   |-- main.tf
|   |   |   |   |-- outputs.tf
|   |   |   |   `-- variables.tf
|   |   |   |-- outputs.tf
|   |   |   |-- policies
|   |   |   |   |-- aws-load-balancer-controller-original.json
|   |   |   |   `-- aws-load-balancer-controller.json
|   |   |   |-- route53.tf
|   |   |   |-- variables.tf
|   |   |   `-- versions.tf
|   |   `-- vpc-alls
|   |       |-- main.tf
|   |       |-- outputs.tf
|   |       `-- variables.tf
|   `-- gcp
|       |-- charts
|       |   |-- argo_project
|       |   |   |-- argocd
|       |   |   |-- main.tf
|       |   |   |-- variables.tf
|       |   |   `-- versions.tf
|       |   |-- system_charts
|       |   |   |-- certificate_manager
|       |   |   |-- gke_external_dns
|       |   |   |-- kong_ingress_controller
|       |   |   |-- main.tf
|       |   |   |-- outputs.tf
|       |   |   `-- variables.tf
|       |   `-- system_configurations
|       |       |-- cert_manager_issuers
|       |       |-- main.tf
|       |       |-- outputs.tf
|       |       `-- variables.tf
|       `-- gke
|           |-- 01-cloud_dns.tf
|           |-- 02-gke.tf
|           |-- 03-outputs.tf
|           `-- variables.tf
|-- terragrunt-dependency-graph.dot
`-- terragrunt.hcl

98 directories, 85 files
```
