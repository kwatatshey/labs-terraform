data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

### The Registration Token for adding new Runners to the GitHab Server. This must be retrieved from your GitLab Instance.
data "aws_ssm_parameter" "runnerRegistrationToken" {
  count = var.github_token == "" && var.enabled ? 1 : 0
  name  = local.token_ssm_parameter
}

data "aws_ssm_parameter" "WebhookServer_token" {
  count = var.webhook_server_secret_enabled && var.enabled && var.webhook_server_enabled ? 1 : 0
  name = local.webhook_secret_token_ssm_parameter
  depends_on = [ aws_ssm_parameter.github_webhook_secret_token ]
}