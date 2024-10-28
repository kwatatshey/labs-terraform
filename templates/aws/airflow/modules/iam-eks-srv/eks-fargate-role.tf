# Create IAM policy that will attached to fargate role. It allows pods to log to Cloudwatch 
resource "aws_iam_policy" "eks-fargate-logging-policy" {
  name        = coalesce(var.eks_fargate_logging_policy_name, "${var.project_prefix}-airflow-eks-fargate-logging-policy-${var.region}")
  path        = "/"
  description = var.eks_fargate_logging_policy_description

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogStream",
            "logs:CreateLogGroup",
            "logs:DescribeLogStreams",
            "logs:PutLogEvents"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}

# Create IAM role that will be attached to fargate profiles
resource "aws_iam_role" "eks_fargate_role" {
  name        = coalesce(var.eks_fargate_role_name, "${var.project_prefix}-airflow-eks-fargate-role-${var.region}")
  description = "Role to be used by fargate."
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "eks-fargate-pods.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
  })
  managed_policy_arns = [aws_iam_policy.eks-fargate-logging-policy.arn,
    "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  ]

}

output "fargate_role_arn" {
  value       = aws_iam_role.eks_fargate_role.arn
  description = "ARN of fargate role"
}
