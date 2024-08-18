resource "aws_sqs_queue" "keda_queue" {
  name                      = var.sqs_name
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  tags = {
    Environment = "keda-poc"
  }
}

resource "aws_sqs_queue_policy" "sqs_access_policy_operator" {
  queue_url = aws_sqs_queue.keda_queue.url
  policy    = data.aws_iam_policy_document.sqs-policy-document.json
}

module "sqs-policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"
  name   = "sqs-queue-policy"
  policy = data.aws_iam_policy_document.sqs-operator-policy-document.json
}

resource "kubectl_manifest" "keda_scaledobject_sqs" {
  yaml_body = local.sqs_scaled_object_yaml

  lifecycle {
    precondition {
      condition     = fileexists(local.sqs_scaled_object_yaml_path)
      error_message = " --> Error: Failed to find '${local.sqs_scaled_object_yaml_path}'. Exit terraform process."
    }
  }
}
