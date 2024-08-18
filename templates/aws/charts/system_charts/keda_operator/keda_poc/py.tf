resource "aws_sqs_queue_policy" "py_sqs_access_policy_operator" {
  queue_url = aws_sqs_queue.keda_queue.url
  policy    = data.aws_iam_policy_document.py-sqs-policy-document.json
}

module "py-sqs-policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"
  name   = "py-sqs-queue-policy"
  policy = data.aws_iam_policy_document.py-sqs-operator-policy-document.json
}

resource "kubectl_manifest" "sa" {
  yaml_body = local.keda_service_accounts_yaml

  lifecycle {
    precondition {
      condition     = fileexists(local.keda_service_accounts_yaml_path)
      error_message = " --> Error: Failed to find '${local.keda_service_accounts_yaml_path}'. Exit terraform process."
    }
  }
}

resource "kubectl_manifest" "app" {
  yaml_body = local.scaled_app_yaml

  lifecycle {
    precondition {
      condition     = fileexists(local.scaled_app_yaml_path)
      error_message = " --> Error: Failed to find '${local.scaled_app_yaml_path}'. Exit terraform process."
    }
  }
}

resource "kubectl_manifest" "py-keda-producer" {
  yaml_body = local.producer_yaml

  lifecycle {
    precondition {
      condition     = fileexists(local.producer_yaml_path)
      error_message = " --> Error: Failed to find '${local.producer_yaml_path}'. Exit terraform process."
    }
  }
}

resource "kubectl_manifest" "py-keda-consumer" {
  yaml_body = local.consumer_yaml

  lifecycle {
    precondition {
      condition     = fileexists(local.consumer_yaml_path)
      error_message = " --> Error: Failed to find '${local.consumer_yaml_path}'. Exit terraform process."
    }
  }
}
