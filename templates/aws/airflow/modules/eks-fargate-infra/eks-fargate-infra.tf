# Create fargate profile for infrastructure kubernetes components in flux-system, kube-system and monitoring namespaces. 
resource "aws_eks_fargate_profile" "eks_fargate_profile_infra" {
  cluster_name           = var.cluster_name
  fargate_profile_name   = var.profile_name
  pod_execution_role_arn = var.fargate_role_arn
  subnet_ids             = var.subnet_ids

  selector {
    namespace = "flux-system"
  }

  selector {
    namespace = "kube-system"
  }

  selector {
    namespace = "monitoring"
  }
}

# Attach addon VPC CNI to EKS cluster
resource "aws_eks_addon" "vpc_cni_addon" {
  cluster_name      = var.cluster_name
  addon_name        = "vpc-cni"
  addon_version     = var.vpc_cni_addon_version
  resolve_conflicts = "OVERWRITE" #resolve_conflicts_on_update 
}

# Attach addon coredns to EKS cluster
resource "aws_eks_addon" "coredns_addon" {
  cluster_name      = var.cluster_name
  addon_name        = "coredns"
  addon_version     = var.coredns_addon_version
  resolve_conflicts = "OVERWRITE" #resolve_conflicts_on_update 
}

# Attach addon kube-proxy to EKS cluster
resource "aws_eks_addon" "kube-proxy_addon" {
  cluster_name      = var.cluster_name
  addon_name        = "kube-proxy"
  addon_version     = var.kube_proxy_addon_version
  resolve_conflicts = "OVERWRITE" #resolve_conflicts_on_update 
}
