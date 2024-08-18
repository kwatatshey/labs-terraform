output "argo_rollouts_url" {
  value = "${var.chart_name}.${var.domain_name}"
}

output "argo_rollouts_demo_url" {
  value = "${var.chart_name}-demo.${var.domain_name}"
}