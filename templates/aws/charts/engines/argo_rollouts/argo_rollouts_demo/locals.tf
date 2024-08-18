locals {
  rollout_yaml_path        = "${path.module}/yamls/rollout.yaml"
  root_service_yaml_path   = "${path.module}/yamls/service-root.yaml"
  canary_service_yaml_path = "${path.module}/yamls/service-canary.yaml"
  stable_service_yaml_path = "${path.module}/yamls/service-stable.yaml"
  ingress_yaml_path        = "${path.module}/yamls/ingress.yaml"
  analysis_yaml_path       = "${path.module}/yamls/analysis-template.yaml"

  analysis_success_yaml = templatefile(local.analysis_yaml_path, {
    namespace = var.namespace
    name_postfix = "success"
    exit_code = 0
  })

  analysis_fail_yaml = templatefile(local.analysis_yaml_path, {
    namespace = var.namespace
    name_postfix = "fail"
    exit_code = 1
  })

  root_service_yaml = templatefile(local.root_service_yaml_path, {
    namespace          = var.namespace
    app_selector_label = var.app_selector_label
  })

  canary_service_yaml = templatefile(local.canary_service_yaml_path, {
    namespace          = var.namespace
    app_selector_label = var.app_selector_label
  })

  stable_service_yaml = templatefile(local.stable_service_yaml_path, {
    namespace          = var.namespace
    app_selector_label = var.app_selector_label
  })

  ingress_yaml = templatefile(local.ingress_yaml_path, {
    release_name      = var.release_name
    domain            = var.domain_name
    namespace         = var.namespace
    service_root_name = kubectl_manifest.root_service.name
  })

  argo_demo_rollout_green_yaml = templatefile(local.rollout_yaml_path, {
    namespace          = var.namespace
    first_analysis     = kubectl_manifest.analysis_template_success.name
    second_analysis    = kubectl_manifest.analysis_template_success.name
    third_analysis     = kubectl_manifest.analysis_template_success.name
    forth_analysis     = kubectl_manifest.analysis_template_success.name
    fifth_analysis     = kubectl_manifest.analysis_template_success.name
    root_service       = kubectl_manifest.root_service.name
    canary_service     = kubectl_manifest.canary_service.name
    stable_service     = kubectl_manifest.stable_service.name
    ingress            = kubectl_manifest.ingress.name
    app_selector_label = var.app_selector_label
    image_tag          = "green"
  })

    argo_demo_rollout_yellow_yaml = templatefile(local.rollout_yaml_path, {
    namespace          = var.namespace
    first_analysis     = kubectl_manifest.analysis_template_success.name
    second_analysis    = kubectl_manifest.analysis_template_success.name
    third_analysis     = kubectl_manifest.analysis_template_success.name
    forth_analysis     = kubectl_manifest.analysis_template_success.name
    fifth_analysis     = kubectl_manifest.analysis_template_success.name
    root_service       = kubectl_manifest.root_service.name
    canary_service     = kubectl_manifest.canary_service.name
    stable_service     = kubectl_manifest.stable_service.name
    ingress            = kubectl_manifest.ingress.name
    app_selector_label = var.app_selector_label
    image_tag          = "yellow"
  })

  argo_demo_rollout_red_yaml = templatefile(local.rollout_yaml_path, {
    namespace          = var.namespace
    first_analysis     = kubectl_manifest.analysis_template_success.name
    second_analysis    = kubectl_manifest.analysis_template_success.name
    third_analysis     = kubectl_manifest.analysis_template_fail.name
    forth_analysis     = kubectl_manifest.analysis_template_success.name
    fifth_analysis     = kubectl_manifest.analysis_template_success.name
    root_service       = kubectl_manifest.root_service.name
    canary_service     = kubectl_manifest.canary_service.name
    stable_service     = kubectl_manifest.stable_service.name
    ingress            = kubectl_manifest.ingress.name
    app_selector_label = var.app_selector_label
    image_tag          = "red"
  })
}