data "aws_iam_policy_document" "py-sqs-policy-document" {
  version = "2012-10-17"
  statement {
    sid    = "SQS"
    effect = "Allow"
    actions = var.sqs_policy_actions
    principals {
      type        = "AWS"
      identifiers = [module.py_irsa_role.iam_role_arn]
    }
  }
}

data "aws_iam_policy_document" "py-sqs-operator-policy-document" {
  version = "2012-10-17"
  statement {
    sid    = "SQS"
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "SQS:GetQueueAttributes",
    ]
    resources = [aws_sqs_queue.keda_queue.arn]
  }
}

data "aws_iam_policy_document" "sqs-policy-document" {
  version = "2012-10-17"
  statement {
    sid    = "SQS"
    effect = "Allow"
    actions = [
      "SQS:GetQueueAttributes",
    ]
    principals {
      type        = "AWS"
      identifiers = [module.keda_irsa_role.iam_role_arn]
    }
  }
}

data "aws_iam_policy_document" "sqs-operator-policy-document" {
  version = "2012-10-17"
  statement {
    sid    = "SQS"
    effect = "Allow"
    actions = [
      "sqs:GetQueueAttributes",
    ]
    resources = [aws_sqs_queue.keda_queue.arn]
  }
}