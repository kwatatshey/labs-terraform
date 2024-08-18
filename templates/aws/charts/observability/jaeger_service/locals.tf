locals {
  values = templatefile("${path.module}/yamls/values.yaml", {
    release_name     = var.name
    domain           = var.domain_name
    certificate_arn  = var.acm_certificate_arn
    scheme           = var.scheme
    demo_enabled     = var.demo_app_enabled
  })

  jaeger_yaml_path = "${path.module}/yamls/values.yaml"
}
