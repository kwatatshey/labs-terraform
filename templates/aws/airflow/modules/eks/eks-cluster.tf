# Pull security groups information based on their name
data "aws_security_group" "eks_sg" {
  for_each = toset(var.security_group_names)
  name     = each.value

}

resource "aws_kms_key" "eks_kms_key" {
  description         = "KMS key for EKS secrets encryption"
  enable_key_rotation = true
}

resource "aws_kms_alias" "eks_kms_key_alias" {
  name          = var.eks_kms_alias
  target_key_id = aws_kms_key.eks_kms_key.key_id
}

# Create EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = var.eks_cluster_role_arn
  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = [for sg in data.aws_security_group.eks_sg : sg.id]
    endpoint_private_access = true
    endpoint_public_access  = false
  }
  version                   = var.kubernetes_version
  enabled_cluster_log_types = var.enabled_cluster_log_types
  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.eks_kms_key.arn
    }
  }
}

