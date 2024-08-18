<h1 align="center">Argo Rollouts</h1>

<p align="center">
  <img src="https://github.com/Opsfleet/labs-terraform/assets/10208228/158b28c2-dafd-4959-a9a4-29eae01fef99" width="250"/>
</p>

# General

## &nbsp;&nbsp; Documentation
  
   | Name | Link |
   |------|------|
   | Git Repository | https://github.com/argoproj/argo-rollouts |
   | Helm Chart Versions | https://github.com/argoproj/argo-helm/pkgs/container/argo-helm%2Fargo-rollouts |

---

# Terraform

## &nbsp;&nbsp; Requirements

  | Name | Version |
  |------|---------|
  | <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
  | <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.12.1 |
  | <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |

## &nbsp;&nbsp; Providers

  | Name | Version |
  |------|---------|
  | <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 2.12.1 |

## &nbsp;&nbsp; Modules

  | Name | Source |
  |------|--------|
  | <a name="module_argo_rollouts_demo"></a> [argo\_rollouts\_demo](#module\_argo\_rollouts\_demo) | ./argo_rollouts_demo |

## &nbsp;&nbsp; Inputs

  | Name | Description | Type | Default | Required |
  |------|:-----------:|:----:|:-------:|:--------:|
  | <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Name of release | `string` | `"argo-rollouts"` | no |
  | <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart to release | `string` | `"2.35.1"` | no |
  | <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create the namespace if it does not exist | `bool` | `true` | no |
  | <a name="input_customized_demo_enabled"></a> [customized\_demo\_enabled](#input\_customized\_demo\_enabled) | Create your own customize rollouts demo |   `bool` | `false` | no |
  | <a name="input_dashboard_enabled"></a> [dashboard\_enabled](#input\_dashboard\_enabled) | Enable argo-rollouts web dashboard | `bool` | `true` | no |
  | <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Roure53 hosted zone name | `string` | n/a | yes |
  | <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace name to deploy helm release | `string` | n/a | yes |
  | <a name="input_repository"></a> [repository](#input\_repository) | Repository to install the chart from | `string` | `"https://argoproj.github.io/  argo-helm"` | no |
  | <a name="input_traffic_light_demo_enabled"></a> [traffic\_light\_demo\_enabled](#input\_traffic\_light\_demo\_enabled) | Create demo rollout | `bool` |   `true` | no |

## &nbsp;&nbsp; Outputs

  | Name | Description | Condition |
  |------|:-----------:|:---------:|
  | <a name="output_argo_rollouts_url"></a> [argo\_rollouts\_url](#output\_argo\_rollouts\_url) | Argo-Rollouts server URL | `argo_rollouts_enabled=true` |
  | <a name="output_argo_rollouts_demo_url"></a> [argo\_rollouts\_demo\_url](#output\_argo\_rollouts\_demo\_url) | Argo-Rollouts web demo application URL | `argo_rollouts_customized_demo_enabled=true`<br>or<br>`argo_rollouts_traffic_light_demo_enabled=true` |

  - These url's will be presented as **_Terraform outputs_**, For example:
   
  <p align="center">
    <img src="https://github.com/Opsfleet/labs-terraform/assets/10208228/1f2952fa-ee6a-4a6b-bcec-f98028addeb9" width="1000"/>
  </p>

---

# Terragrunt

## &nbsp;&nbsp; Configuration File
  
  | Name | Link |
  |------|------|
  | <a name="link_terragrunt.hcl"></a> [terragrunt.hcl](#link\_terragrunt.hcl) | https://github.com/Opsfleet/labs-terraform/blob/main/labs/dev/aws/sandbox/eu-west-1/infra-01/app_cluster/030_engines/terragrunt.hcl |

## &nbsp;&nbsp; Parameters

  | Name | Description | Type | Default |
  |------|:-----------:|:----:|:-------:|
  | <a name="input_argo_rollouts_enabled"></a> [argo\_rollouts\_enabled](#input\_argo\_rollouts\_enabled) | Deploy Argo-Rollouts Helm chart | `bool` | `false` |
  | <a name="input_argo_rollouts_dashboard_enabled"></a> [argo\_rollouts\_dashboard\_enabled](#input\_argo\_rollouts\_dashboard\_enabled) | Enable Argo-Rollouts web dashboard | `bool` | `false` |
  | <a name="input_argo_rollouts_namespace"></a> [argo\_rollouts\_namespace](#input\_argo\_rollouts\_namespace) | The namespace where Argo-Rollouts resources will be deployed | `string` | `argo-rollouts` |
  | <a name="input_argo_rollouts_customized_demo_enabled"></a> [argo\_rollouts\_customized\_demo\_enabled](#input\_argo\_rollouts\_customized\_demo\_enabled) | Run your own customized demo by deploying only initial resources | `bool` | `false` |
  | <a name="input_argo_rollouts_traffic_light_demo_enabled"></a> [argo\_rollouts\_traffic\_light\_demo\_enabled](#input\_argo\_rollouts\_traffic\_light\_demo\_enabled) | Run an automatic demo (Traffic Light 🚦) | `bool` | `false` |

---

# Demos
## &nbsp;&nbsp; Customized demo
#### &nbsp;&nbsp;&nbsp;&nbsp; <ins>Type</ins>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Canary deployment.
#### &nbsp;&nbsp;&nbsp;&nbsp; <ins>Purpose</ins>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; To give each engineer the ability to execute and manage his own demo by gradually shift traffic to a new application version during<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; an update.
#### &nbsp;&nbsp;&nbsp;&nbsp; <ins>Resources</ins>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1. One Rollout instance (Green application).

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2. One Service instance. 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3. One Ingress instance.

## &nbsp;&nbsp; Traffic-Light demo 🚦
#### &nbsp;&nbsp;&nbsp;&nbsp; <ins>Type</ins>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Canary deployment.
#### &nbsp;&nbsp;&nbsp;&nbsp; <ins>Purpose</ins>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; To give each engineer the ability to automatically deploy different versions of rollouts and to witness two **_different_** results.<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; One, a successfull rollout deployed and the other a rollout that unsuccessfully deployed, which will trigger a **_rollback_**.
#### &nbsp;&nbsp;&nbsp;&nbsp; <ins>Resources</ins>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1. Three Rollouts instances (🟩 , 🟨 & 🟥 applications).

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2. Two AnalysisTemplate instances (Simulates a **succeeded**/**failed** process).

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3. Three Service instances (root, canary & stable).

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4. One Ingress instance.

#### &nbsp;&nbsp;&nbsp;&nbsp; <ins>Demo Flow</ins>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1. Deploying 🟩 application --> **_success_**.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2. Waiting for _30s_.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3. Deploying 🟨 application --> **_success_**.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4. Green application terminating.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5. Waiting for _90s_.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6. Deploying 🟥 application --> **_fail_**.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7. Rollback to latest stable version (🟨 application).

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8. 🟥 application terminating.

#### &nbsp;&nbsp;&nbsp;&nbsp; <ins>Rollout Strategy</ins>

  ```
  strategy:
    canary:
      steps:

      - setWeight: 20
      - pause: {duration: 10s}
      - analysis:
          templates:                         🟩 🟨 🟥
          - templateName: ${first_analysis}  ✅ ✅ ✅

      - setWeight: 40
      - pause: {duration: 10s}
      - analysis:
          templates:
          - templateName: ${second_analysis} ✅ ✅ ✅

      - setWeight: 60
      - pause: {duration: 10s}
      - analysis:
          templates:
          - templateName: ${third_analysis}  ✅ ✅ ❌

      - setWeight: 80
      - pause: {duration: 10s}
      - analysis:
          templates:
          - templateName: ${forth_analysis}  ✅ ✅

      - setWeight: 100
      - pause: {duration: 10s}
      - analysis:
          templates:
          - templateName: ${fifth_analysis}  ✅ ✅ 
  ```

#### &nbsp;&nbsp;&nbsp;&nbsp; <ins>AnalysisTemplate Output</ins>

  ```
  containers:
  - name: simulator
    image: alpine:3.8
    env:
    - name: EXIT_CODE
      value: "${exit_code}"
    command: ["/bin/sh"]
    args: ["-c", "exit $(EXIT_CODE)"]      
  ```

---

# Argo Rollouts Extension for ArgoCD

  | Name | Description | Type | Default |
  |------|:-----------:|:----:|:-------:|
  | <a name="input_argocd_enabled"></a> [argocd\_enabled\_enable](#input\_argocd\_enabled) | Enables ArgoCD Helm chart installation | `bool` | `false` |
  | <a name="input_argo_rollouts_extension_enable"></a> [argo\_rollouts\_extension\_enable](#input\_argo\_rollouts\_extension\_enable) | Enables Argo-Rollouts dashboard UI on ArgoCD | `bool` | `false` |

## &nbsp;&nbsp; Why using this feature? 🤔


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1. Argo-Rollouts server UI does not support authentication or RBAC. ❌

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2. Argo-Rollouts CLI is powerful but requires cluster access. ❌

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3. This extension allows us to control all Argo-Rollouts actions. ✅

  <p align="center">
    <img src="https://github.com/Opsfleet/labs-terraform/assets/10208228/3a714256-f77e-4bfe-ae73-30a4c9f0d9ff" width="1000"/>
  </p>

---

# UI Dashboards
## &nbsp;&nbsp; Argo-Rollouts server
 
  <p align="center">
    <img src="https://github.com/Opsfleet/labs-terraform/assets/10208228/a5b2ce17-2abe-41d7-9858-d7fc63a45314" width="1000"/>
  </p>

  ---
## &nbsp;&nbsp; Argo-Rollouts web demo application
 
  <p align="center">
    <img src="https://github.com/Opsfleet/labs-terraform/assets/10208228/9bcd6418-0fdb-43f9-8c2f-64978c3b9775" width="1000"/>
  </p>

---

# Kubectl Plugin (Optional)
## &nbsp;&nbsp; Kubectl Plugin Instllation

  ```
  $ curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-darwin-amd64

  $ chmod +x ./kubectl-argo-rollouts-darwin-amd64

  $ sudo mv ./kubectl-argo-rollouts-darwin-amd64 /usr/local/bin/kubectl-argo-rollouts
  ```
  ---
## &nbsp;&nbsp; Watch your rollouts 
  ```
  $ kubectl argo rollouts get rollout ${ROLLOUT} -n ${NAMESPACE} --watch
  ```
  
  <p align="center">
    <img src="https://github.com/Opsfleet/labs-terraform/assets/10208228/d1338468-fe22-41df-9c17-5e86f54ced30" width="800"/>
  </p>

---
## Have Fun 😃
