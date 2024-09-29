# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 20.0"

#   cluster_name    = var.cluster_name
#   cluster_version = var.kubernets_version

#   cluster_endpoint_private_access          = true
#   cluster_endpoint_public_access           = true
#   enable_cluster_creator_admin_permissions = true # Description: Indicates whether or not to add the cluster creator (the identity used by Terraform) as an administrator via access entry
#   # access_entries                  = merge(local.user_access_entries, local.role_access_entries)

#   vpc_id     = var.vpc_id
#   subnet_ids = concat(var.public_subnet_ids, var.private_subnet_ids)

#   enable_irsa               = true
#   cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

#   eks_managed_node_groups = {
#     # for prod additional group on-demand
#     spot = {
#       desired_size = 3
#       min_size     = 1
#       max_size     = 5

#       labels = {
#         role = "spot"
#       }

#       instance_types    = var.spot_instance_types
#       capacity_type     = "SPOT"
#       enable_monitoring = true
#       network_interfaces = [{
#         delete_on_termination       = true
#         associate_public_ip_address = true
#       }]
#       block_device_mappings = {
#         xvda = {
#           device_name = "/dev/xvda"
#           ebs = {
#             volume_size           = 300
#             volume_type           = "gp3"
#             iops                  = 3000
#             throughput            = 150
#             encrypted             = true
#             kms_key_id            = module.ebs_kms_key.key_arn
#             delete_on_termination = true
#           }
#         }
#       }

#       metadata_options = {
#         http_endpoint               = "enabled"
#         http_tokens                 = "required"
#         http_put_response_hop_limit = 2
#         instance_metadata_tags      = "enabled"
#       }
#       #Description: Path to a local, custom user data template file to use when rendering user data
#       user_data_template_path = ""
#     }
#   }

#   tags = var.tags

#   node_security_group_tags = {
#     "kubernetes.io/cluster/${var.cluster_name}" = "owned"
#   }
# }


############################################################################################
# new 

#tfsec:ignore:aws-eks-no-public-cluster-access
#tfsec:ignore:aws-eks-no-public-cluster-access-to-cidr
#tfsec:ignore:aws-ec2-no-public-egress-sgr
#tfsec:ignore:aws-ec2-no-public-ingress-sgr
module "eks" {
  source                                   = "terraform-aws-modules/eks/aws"
  version                                  = "20.8.5"
  cluster_name                             = var.cluster_name
  cluster_version                          = var.kubernets_version
  cluster_endpoint_private_access          = false
  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true
  enable_irsa                              = true
  iam_role_use_name_prefix                 = false
  cluster_enabled_log_types                = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  subnet_ids                               = concat(var.public_subnet_ids, var.private_subnet_ids)
  #subnet_ids = concat(var.public_subnet_ids)
  vpc_id     = var.vpc_id
  # cluster_additional_security_group_ids    = [aws_security_group.node_security_group_additional_rules.id, aws_security_group.alb.id]
  # cluster_additional_security_group_ids = [aws_security_group.cluster_additional_security_group_ids.id]
  cluster_additional_security_group_ids = [
    module.security_alb_ingress.security_group_id,
    module.security_node.security_group_id
  ]
  # cluster_additional_security_group_ids = concat(
  #   var.create_node_security_group ? [aws_security_group.main[1].id] : [], # node_security_group
  # [aws_security_group.main[0].id])
  cluster_security_group_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
  access_entries = merge(local.user_access_entries, local.role_access_entries)
  # control_plane_subnet_ids                 = var.control_plane_subnet_ids
  # tags = local.all_tags
  tags = var.tags
  # tags = merge(local.tags, {
  #   # NOTE - if creating multiple security groups with this module, only tag the
  #   # security group that Karpenter should utilize with the following tag
  #   # (i.e. - at most, only one security group should have this tag in your account)
  #   "karpenter.sh/discovery" = local.name
  # })
}

# locals {
#   private = "private"
# }

# locals {
#   common_tags = {
#     "karpenter.sh/discovery" = local.private
#     "Environment"            = var.environment
#   }

#   additional_tags = {
#     GithubRepo = "terraform-aws-eks"
#     GithubOrg  = "terraform-aws-modules"
#   }

#   all_tags = merge(local.common_tags, local.additional_tags)
# }


resource "aws_ec2_tag" "karpenter_public" {
  for_each    = toset(var.public_subnet_ids)
  resource_id = each.key
  key         = "karpenter.sh/discovery"
  value       = "${var.cluster_name}/public"
}

resource "aws_ec2_tag" "karpenter_private" {
  for_each    = toset(var.private_subnet_ids)
  resource_id = each.key
  key         = "karpenter.sh/discovery"
  value       = "${var.cluster_name}/private"
}

resource "aws_ec2_tag" "cluster_public" {
  for_each    = toset(var.public_subnet_ids)
  resource_id = each.key
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "owned"
}

resource "aws_ec2_tag" "cluster_private" {
  for_each    = toset(var.private_subnet_ids)
  resource_id = each.key
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "owned"
}
