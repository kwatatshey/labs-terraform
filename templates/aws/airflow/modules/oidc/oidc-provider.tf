# Pull TLS certificate info for OIDC for given EKS cluster
data "tls_certificate" "eks" {
  url = var.eks_oidc_url

}

# Create IAM OIDC Identity provider
resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = var.eks_oidc_url
}
