# Create IAM policy for kubernetes pods to allow secretmanager access ans S3
resource "aws_iam_policy" "eks-pod-policy" {
  name        = coalesce(var.eks_pod_policy_name, "${var.project_prefix}-airflow-eks-pod-policy-${var.region}")
  path        = "/"
  description = var.eks_pod_policy_description

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "SecretsManagerFull",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetResourcePolicy",
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret",
            "secretsmanager:ListSecretVersionIds"
          ],
          "Resource" : "arn:aws:secretsmanager:*:${var.aws_account_number}:secret:${var.project_prefix}/airflowfdna/*"
        },
        {
          "Sid" : "SecretsManagerBasic",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetRandomPassword",
            "secretsmanager:ListSecrets"
          ],
          "Resource" : "*"
        },
        {
          "Action" : [
            "s3:*"
          ],
          "Resource" : [
            "arn:aws:s3:::${var.project_prefix}*airflowfdna*",
            "arn:aws:s3:::${var.project_prefix}*airflowfdna*/*",
            "arn:aws:s3:::${var.project_prefix}-airflow*",
            "arn:aws:s3:::${var.project_prefix}-airflow*/*"
          ],
          "Effect" : "Allow",
          "Sid" : "S3access"
        },
        {
          "Action" : [
            "sts:AssumeRole"
          ],
          "Resource" : "*",
          "Effect" : "Allow",
          "Sid" : "AssumeRole"
        }
      ]
    }
  )
}

# Create IAM role for kubernetes pods to allow secretmanager access and S3
resource "aws_iam_role" "eks-pod-role" {
  name        = coalesce(var.eks_pod_role_name, "${var.project_prefix}-airflow-eks-pod-role-${var.region}")
  description = "Role to be used by Airflow EKS pods to access AWS resources."
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
  managed_policy_arns = [aws_iam_policy.eks-pod-policy.arn
  ]

}
