output "eks_cluster_name" {
  description = "Name of EKS K8S cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_arn" {
  description = "ARN of EKS K8S cluster"
  value       = module.eks.cluster_arn
}


output "eks_cluster_id" {
  description = "ID of EKS K8S cluster"
  value       = module.eks.cluster_id
}

# output "eks_primary_security_group_id" {
#   value = module.eks.cluster_primary_security_group_id
# }

# output "eks_version" {
#   description = "Version of EKS K8S cluster"
#   value       = module.eks.cluster_version
# }

# output "eks_service_role_arn" {
#   description = "ARN of the EKS cluster service role"
#   value       = module.eks.cluster_service_role_arn
# }

# output "eks_service_cidr" {
#   description = "CIDR block for the EKS cluster service"
#   value       = module.eks.cluster_service_cidr
# }


output "eks_region" {
  description = "Region where the cluster deployed"
  value       = data.aws_region.current.name
}

output "eks_endpoint" {
  description = "Endpoint of EKS K8S cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_certificate" {
  description = "Certificate of EKS K8S cluster (base64)"
  value       = module.eks.cluster_certificate_authority_data
}

output "eks_token" {
  description = "Authorization token for EKS K8S cluster"
  value       = data.aws_eks_cluster_auth.eks.token
  sensitive   = true
}

output "eks_iam_role_arn" {
  value = module.eks.cluster_iam_role_arn
}

output "eks_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = module.eks.cluster_oidc_issuer_url
}

# output "eks_oidc_provider" {
#   description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
#   value       = module.eks.oidc_provider
# }

output "eks_oidc_provider_arn" {
  description = "The ARN of the OpenID Connect identity provider"
  value       = module.eks.oidc_provider_arn
}

output "vpc_id" {
  description = "VPC ID, where the cluster was deployed"
  value       = var.vpc_id
}

output "r53_zone_name" {
  description = "Cluster route53 zone name"
  value       = aws_route53_zone.cluster_zone.name
}

output "r53_zone_id" {
  description = "Cluster route53 zone id"
  value       = aws_route53_zone.cluster_zone.id
}

output "acm_certificate_arn" {
  value = module.certificate.acm_certificate_arn
}

# Nodegroup outputs
# output "node_group_autoscaling_group_names" {
#   value = module.eks_managed_node_groups.node_group_autoscaling_group_names
# }

# output "additional_policy_arn" {
#   value = module.additional_policy.arn
# }

# output "node_iam_role_arn" {
#   value = module.eks_managed_node_groups.iam_role_arn
# }

# output "node_iam_role_name" {
#   value = module.eks_managed_node_groups.iam_role_name
# }

##################################################
