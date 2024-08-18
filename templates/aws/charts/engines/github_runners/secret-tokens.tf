resource "random_password" "password" {
  length      = 36
  special     = false
  min_upper   = 6
  min_lower   = 6
  min_numeric = 6
}

resource "aws_ssm_parameter" "github_webhook_secret_token" {
  count       = var.webhook_server_secret_enabled && var.enabled && var.webhook_server_enabled ? 1 : 0
  name        = local.webhook_secret_token_ssm_parameter
  type        = "SecureString"
  description = "Github Webhook server secret toke. To allow Github connect to webhook server."
  value       = random_password.password.result
}

resource "aws_ssm_parameter" "runnerRegistrationToken" {
  count       = var.enabled ? 1 : 0
  name        = local.token_ssm_parameter
  description = "The Registration Token for adding new Runners to the GitHub Server. This must be retrieved from your GitLab Instance."
  type        = "SecureString"
  value       = local.runnerRegistrationToken
}