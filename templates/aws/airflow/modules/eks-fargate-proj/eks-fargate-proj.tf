# Pull info about IAM role for fargate profiles
data "aws_iam_role" "fargate_role" {
  name = var.fargate_role_name
}

# Create fargate profile for Airflow instance
resource "aws_eks_fargate_profile" "eks_fargate_profile_app" {
  cluster_name           = var.cluster_name
  fargate_profile_name   = var.profile_name
  pod_execution_role_arn = data.aws_iam_role.fargate_role.arn
  subnet_ids             = var.subnet_ids

  selector {
    namespace = var.namespace
  }

}
