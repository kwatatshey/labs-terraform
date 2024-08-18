resource "helm_release" "airflow" {
  name             = var.name
  chart            = "airflow"
  repository       = "https://airflow.apache.org"
  create_namespace = var.namespace == "default" ? false : true
  version          = var.chart_version
  namespace        = var.namespace
  values           = [local.base_values]

  ## Higher timeout that CaS would be able to bring nodes
  timeout = 600
}