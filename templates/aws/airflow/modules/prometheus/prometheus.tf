# Create Cloudwatch log group for prometheus
resource "aws_cloudwatch_log_group" "prometheus_log_group" {
  name = var.prometheus_log_group

}

# Create prometheus workspace
resource "aws_prometheus_workspace" "prometheus" {
  alias = var.prometheus_alias

  logging_configuration {
    log_group_arn = "${aws_cloudwatch_log_group.prometheus_log_group.arn}:*"
  }
}

# Policy document for prometheus role
data "aws_iam_policy_document" "prometheus_policy_document" {
  policy_id = "prometheus_policy_document"
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    dynamic "principals" {
      for_each = var.prometheus_agent_roles
      content {
        type        = "AWS"
        identifiers = ["${principals.value}"]
      }
    }
    sid = "prometheusaccess"
  }
}


# Create an IAM role to be assumed to remote write logs to central prometheus
resource "aws_iam_role" "prometheus_central_role" {
  name                = "aparflow-central-prometheus-role"
  description         = "Role to be used to remote write to prometheus."
  assume_role_policy  = data.aws_iam_policy_document.prometheus_policy_document.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonPrometheusRemoteWriteAccess"]
  tags = {
    SCPExceptionToAllowPrometheusActions = "yes"
  }
}