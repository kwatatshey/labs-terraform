# Deploy central prometheus
module "prometheus" {
  source = "../../modules/prometheus"

  prometheus_log_group   = "/aws/vendedlogs/central-prometheus"
  prometheus_alias       = "aparflow-prometheus-central-monitoring"
  prometheus_agent_roles = var.prometheus_agent_roles
}

# Deploy central SNS
module "sns" {
  source = "../../modules/sns"

  sns_topic_name              = "aparflow-sns-topic-central-monitoring-alerts"
  sns_subscription_email_list = var.sns_subscription_email_list
}

# Deploy central SNS for Moogsoft alerts
module "moogsoft-alerts-sns" {
  source = "../../modules/sns"

  sns_topic_name              = "aparflow-sns-topic-central-moogsoft-alerts"
  sns_subscription_email_list = var.sns_subscription_email_list
}

# Deploy lambda function for Grafana to Moogsoft integration
module "moogsoft-alerts-lambda" {
  source = "../../modules/lambda"

  file_path               = "lambda-grafana-moogsoft/lambda-grafana-moogsoft.zip"
  function_name           = "grafana-to-moogsoft-alerts"
  role_name               = "grafana-to-moogsoft-alerts-role"
  handler                 = "lambda_function.lambda_handler"
  runtime                 = "python3.9"
  subnet_ids              = var.subnet_ids
  security_group_ids      = var.security_group_ids
  lambda_role_policy_arns = var.lambda_moogsoft_policy_arns
  sns_lambda_trigger      = data.aws_sns_topic.lambda_moogsoft_sns_topic.arn
  custom_policy_statement = var.custom_policy_statement
  custom_policy_name      = "moogsoft-secrets-manager"
  lambda_additional_tags  = var.lambda_moogsoft_additional_tags
}

data "aws_sns_topic" "lambda_moogsoft_sns_topic" {
  name = "aparflow-sns-topic-central-moogsoft-alerts"
}

