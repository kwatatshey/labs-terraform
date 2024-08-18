# analysis-simulator-success
resource "kubectl_manifest" "analysis_template_success" {
  yaml_body = local.analysis_success_yaml

  lifecycle {
    precondition {
      condition     = fileexists(local.analysis_yaml_path)
      error_message = " --> Error: Failed to find '${local.analysis_yaml_path}'. Exit terraform process."
    }
  }
}

# analysis-simulator-fail
resource "kubectl_manifest" "analysis_template_fail" {
  yaml_body = local.analysis_fail_yaml

  lifecycle {
    precondition {
      condition     = fileexists(local.analysis_yaml_path)
      error_message = " --> Error: Failed to find '${local.analysis_yaml_path}'. Exit terraform process."
    }
  }
}

# Root service (For rollouts-demo container)
resource "kubectl_manifest" "root_service" {
  yaml_body = local.root_service_yaml

  lifecycle {
    precondition {
      condition     = fileexists(local.root_service_yaml_path)
      error_message = " --> Error: Failed to find '${local.root_service_yaml_path}'. Exit terraform process."
    }
  }
}

# Canary service
resource "kubectl_manifest" "canary_service" {
  yaml_body = local.canary_service_yaml

  lifecycle {
    precondition {
      condition     = fileexists(local.canary_service_yaml_path)
      error_message = " --> Error: Failed to find '${local.canary_service_yaml_path}'. Exit terraform process."
    }
  }
}

# Stable service
resource "kubectl_manifest" "stable_service" {
  yaml_body = local.stable_service_yaml

  lifecycle {
    precondition {
      condition     = fileexists(local.stable_service_yaml_path)
      error_message = " --> Error: Failed to find '${local.stable_service_yaml_path}'. Exit terraform process."
    }
  }
}

# Ingress (For rollouts-demo container)
resource "kubectl_manifest" "ingress" {
  yaml_body = local.ingress_yaml

  depends_on = [
    kubectl_manifest.root_service
  ]

  lifecycle {
    precondition {
      condition     = fileexists(local.ingress_yaml_path)
      error_message = " --> Error: Failed to find '${local.ingress_yaml_path}'. Exit terraform process."
    }
  }
}

# Rollout - Green (Success)
resource "kubectl_manifest" "argo_rollouts_demo_green" {
  yaml_body = local.argo_demo_rollout_green_yaml

  depends_on = [
    kubectl_manifest.analysis_template_success,
    kubectl_manifest.analysis_template_fail,
    kubectl_manifest.root_service,
    kubectl_manifest.canary_service,
    kubectl_manifest.stable_service,
    kubectl_manifest.ingress
  ]

  lifecycle {
    precondition {
      condition     = fileexists(local.rollout_yaml_path)
      error_message = " --> Error: Failed to find '${local.rollout_yaml_path}'. Exit terraform process."
    }
  }
}

# Wait for yellow Rollout
resource "time_sleep" "wait_60_seconds" {
  count           = var.traffic_light_demo_enabled ? 1 : 0
  create_duration = "60s"

  depends_on = [
    kubectl_manifest.argo_rollouts_demo_green
  ]
}

# Rollout - Yellow (Success)
resource "kubectl_manifest" "argo_rollouts_demo_yellow" {
  count     = var.traffic_light_demo_enabled ? 1 : 0
  yaml_body = local.argo_demo_rollout_yellow_yaml

  depends_on = [
    time_sleep.wait_60_seconds
  ]

  lifecycle {
    precondition {
      condition     = fileexists(local.rollout_yaml_path)
      error_message = " --> Error: Failed to find '${local.rollout_yaml_path}'. Exit terraform process."
    }
  }
}

# Wait for red Rollout
resource "time_sleep" "wait_120_seconds" {
  count           = var.traffic_light_demo_enabled ? 1 : 0
  create_duration = "120s"

  depends_on = [
    kubectl_manifest.argo_rollouts_demo_yellow
  ]
}

# Rollout - Red (Fail)
resource "kubectl_manifest" "argo_rollouts_demo_red" {
  count     = var.traffic_light_demo_enabled ? 1 : 0
  yaml_body = local.argo_demo_rollout_red_yaml

  depends_on = [
    time_sleep.wait_120_seconds
  ]

  lifecycle {
    precondition {
      condition     = fileexists(local.rollout_yaml_path)
      error_message = " --> Error: Failed to find '${local.rollout_yaml_path}'. Exit terraform process."
    }
  }
}