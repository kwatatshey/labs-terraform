resource "aws_lambda_function" "lambda_function" {
  filename         = var.file_path
  function_name    = var.function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = var.handler
  source_code_hash = filebase64sha256(var.file_path)
  runtime          = var.runtime
  publish          = var.publish
  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }
  tags = var.lambda_additional_tags
}

resource "aws_iam_role" "lambda_role" {
  name = var.role_name
  path = "/service-role/"

  managed_policy_arns = var.lambda_role_policy_arns

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_sns_topic_subscription" "lambda_sns_subscription" {
  count     = var.sns_subscription_enabled ? 1 : 0
  topic_arn = var.sns_lambda_trigger
  protocol  = "lambda"
  endpoint  = aws_lambda_function.lambda_function.arn
}

resource "aws_lambda_permission" "sns_trigger" {
  count         = var.sns_subscription_enabled ? 1 : 0
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_lambda_trigger
}


resource "aws_iam_policy" "custom_policy" {
  count = var.custom_policy_enabled ? 1 : 0
  name  = var.custom_policy_name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : var.custom_policy_statement
  })
}

resource "aws_iam_policy_attachment" "attach_custom_policy" {
  name       = "attach_custom_policy"
  policy_arn = aws_iam_policy.custom_policy[0].arn
  roles      = [aws_iam_role.lambda_role.name]
  depends_on = [
    aws_iam_policy.custom_policy
  ]
}
