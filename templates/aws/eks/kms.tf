module "ebs_kms_key" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 2.1"

  description = "Customer managed key to encrypt EKS managed node group volumes"

  # Policy
  key_administrators = [
    data.aws_caller_identity.current.arn
  ]

  key_service_roles_for_autoscaling = [
    # required for the ASG to manage encrypted volumes for nodes
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
    # required for the cluster / persistentvolume-controller to create encrypted PVCs
    # var.cluster_iam_role_arn
    module.eks.cluster_iam_role_arn
  ]

  # Aliases
  aliases = var.worker_nodes_kms_key_aliases

  # tags = local.tags
  tags = var.tags
}

# data "aws_caller_identity" "current" {}
# locals {
#   tags = {
#     GithubRepo = "terraform-aws-eks"
#     GithubOrg  = "terraform-aws-modules"
#     Source     = "github.com/terraform-aws-modules/terraform-aws-eks"
#   }
# }
