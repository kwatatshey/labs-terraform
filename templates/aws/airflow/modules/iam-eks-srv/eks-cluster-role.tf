# Create an IAM role to be attached to EKS cluster control plane
resource "aws_iam_role" "eks_cluster_role" {
  name        = coalesce(var.eks_cluster_role_name, "${var.project_prefix}-airflow-eks-cluster-role-${var.region}")
  description = "Role to be used by EKS cluster for Airflow."
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "eks.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    , "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
    , "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    , "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ]

}

output "cluster_role_arn" {
  value       = aws_iam_role.eks_cluster_role.arn
  description = "ARN of cluster role"
}
