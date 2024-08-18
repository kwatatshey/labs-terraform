### Helm Actions Runner Controller deployment
resource "helm_release" "actions-runner-controller" {
  depends_on       = [ aws_ssm_parameter.runnerRegistrationToken[0], aws_ssm_parameter.github_webhook_secret_token ]
  count = var.enabled ? 1 : 0

  name             = "actions-runner-controller"
  repository       = "https://actions-runner-controller.github.io/actions-runner-controller"
  chart            = "actions-runner-controller"
  namespace        = var.namespace
  create_namespace = true

  set {
    name  = "authSecret.create"
    value = true
  }
  set {
    name  = "authSecret.github_token"
    value = local.runnerRegistrationToken
  }
  set {
    name  = "serviceAccount.create"
    value = true
  }
  set {
    name  = "serviceAccount.name"
    value = var.serviceaccount
  }
  set {
    name  = "runnerGithubURL"
    value = var.runnerGithubURL
  }

  values = [ local.githubWebhookServer ]
}