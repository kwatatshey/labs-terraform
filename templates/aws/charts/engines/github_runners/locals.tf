locals {
  github_helm_charts_s3_bucket = var.github_helm_charts_s3_bucket == "" ? "arn:aws:s3:::${var.github_helm_charts_s3_bucket}" : "arn:aws:s3:::${var.environment}-helm-charts"
  runnerRegistrationToken      = var.enabled && var.github_token == "" ? data.aws_ssm_parameter.runnerRegistrationToken[0].value : var.github_token
  #  token_ssm_parameter          = var.token_ssm_parameter == "" ? "/${var.environment}/github/GitHubRegistrationToken" : var.token_ssm_parameter
  token_ssm_parameter                = var.ssm_prefix == "/github" ? "/${var.environment}${var.ssm_prefix}/GitHubRegistrationToken" : "${var.ssm_prefix}/GitHubRegistrationToken"
  webhook_secret_token_ssm_parameter = "${var.ssm_prefix}/GitHubWebhookToken"

  provider_arn = var.cluster_oidc_provider_arn

  githubWebhookServer_token = var.webhook_server_secret_enabled && var.enabled && var.webhook_server_enabled ? data.aws_ssm_parameter.WebhookServer_token[0].value : random_password.password.result
  #  githubWebhookServer_ingress_hosts = { "host": "github-webhook.mydomain.com", "paths": [ {"path": "/", "pathType": "Prefix" }] }

  ### Github Webhook Server configuration. Variables passed in YAML raw format.
  githubWebhookServer = var.webhook_server_enabled == false || var.webhook_server_host == null ? "" : <<EOF
githubWebhookServer:
  enabled: true
  secret:
    enabled: ${var.webhook_server_secret_enabled}
    create: true
    name: "github-webhook-server"
    github_webhook_secret_token: ${local.githubWebhookServer_token}
  ingress:
    enabled: true
    ingressClassName: "alb"
    annotations:
      alb.ingress.kubernetes.io/scheme: "internet-facing"
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}]'
      alb.ingress.kubernetes.io/certificate-arn: "arn:aws:acm:eu-west-1:782824484157:certificate/f531fccc-6bbf-4259-9162-3abb8f84160f"
    hosts:
      - host: ${var.webhook_server_host}
        paths:
          - path: ${var.webhook_server_path}
            pathType: "Prefix"
EOF
  #  depends_on = [ aws_ssm_parameter.github_webhook_secret_token ]
}
