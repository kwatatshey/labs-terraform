# Create IAM policy for kubernetes tool prometheus
resource "aws_iam_policy" "eks-prometheus-policy" {
  name        = "${var.project_prefix}-airflow-eks-prometheus-policy-${var.region}"
  path        = "/"
  description = "Policy used by Prometheus on eks cluster to remote write metrics."

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "sts:AssumeRole"
          ],
          "Resource" : "arn:aws:iam::806735670197:role/aparflow-central-prometheus-role"
        }
      ]
    }
  )
}

# Create IAM role for kubernetes tool external dns
resource "aws_iam_role" "eks-prometheus-role" {
  name        = "${var.project_prefix}-airflow-eks-prometheus-role-${var.region}"
  description = "Role to be used by prometheus to remote write metrics."
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Federated" : "arn:aws:iam::${var.aws_account_number}:oidc-provider/${replace(var.eks_oidc_url, "https://", "")}"
          },
          "Action" : "sts:AssumeRoleWithWebIdentity",
          "Condition" : {
            "StringLike" : {
              "${replace(var.eks_oidc_url, "https://", "")}:sub" : "system:serviceaccount:*:*"
            }
          }
        }
      ]
    }
  )
  managed_policy_arns = [aws_iam_policy.eks-prometheus-policy.arn
  ]

}
