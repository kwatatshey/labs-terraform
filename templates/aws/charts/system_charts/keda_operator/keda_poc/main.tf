module "keda_irsa_role" {
  source           = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version          = "5.34.0"
  create_role      = true
  role_name_prefix = var.keda_service_account_name

  role_policy_arns = {
    policy = module.sqs-policy.arn
  }

  oidc_providers = {
    ex = {
      provider_arn               = var.cluster_oidc_provider_arn
      namespace_service_accounts = ["${var.namespace}:${var.keda_service_account_name}"]
    }
  }
}

module "py_irsa_role" {
  source           = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version          = "5.34.0"
  create_role      = true
  role_name_prefix = var.py_service_account_name

  role_policy_arns = {
    policy = module.py-sqs-policy.arn
  }

  oidc_providers = {
    ex = {
      provider_arn               = var.cluster_oidc_provider_arn
      namespace_service_accounts = ["${var.namespace}:${var.py_service_account_name}"]
    }
  }
}
