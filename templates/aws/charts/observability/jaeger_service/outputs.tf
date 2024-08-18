output "jaeger_url" {
  value = "https://${var.name}.${var.domain_name}"
}

output "jaeger_demo_url" {
  value = var.demo_app_enabled ? "https://hotrod-${var.name}.${var.domain_name}" : null
}
