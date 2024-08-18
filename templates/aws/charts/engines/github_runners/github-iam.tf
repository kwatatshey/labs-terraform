### Create IAM Role with policies for Github Actions Controller
module "actions_runner_controller" {
  count = var.enabled ? 1 : 0

  source                                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                               = "5.10.0"
  create_role                           = var.enabled
  role_name_prefix                      = var.serviceaccount
  attach_external_secrets_policy        = true
  external_secrets_ssm_parameter_arns   = [ "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${local.token_ssm_parameter}" ]
  external_secrets_secrets_manager_arns = [ "arn:aws:none" ]

  #  cert_manager_hosted_zone_arns         = local.github_runner.r53_parent_zone_id

  oidc_providers = {
    ex = {
      provider_arn               = local.provider_arn
      namespace_service_accounts = ["${var.namespace}:${var.serviceaccount}"]
    }
  }
}

### Runner iam policy for helm deployments
#   - allow access to S3 bucket to store Helm charts
#   - allow access to SSM values /<environment_name>/*
#   - allow access to ECR, to upload and download images
###

data "aws_iam_policy_document" "github-runner-helm-policy" {
  statement {
    sid    = "helmS3ReadOnly"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${local.github_helm_charts_s3_bucket}",
      "arn:aws:s3:::${local.github_helm_charts_s3_bucket}/*"
    ]
  }

  statement {
    sid    = "SSMParameterStore"
    effect = "Allow"
    actions = [
      "ssm:DescribeParameters",
      "ssm:GetParameter*"
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.environment}/*"
    ]
  }

  statement {
    sid    = "ECR"
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "github-runner-helm-deploy-policy" {
  count = var.enabled ? 1 : 0

  name   = "github-runner-helm-deploy-policy"
  role   = module.actions_runner_controller[0].iam_role_name
  policy = data.aws_iam_policy_document.github-runner-helm-policy.json
}