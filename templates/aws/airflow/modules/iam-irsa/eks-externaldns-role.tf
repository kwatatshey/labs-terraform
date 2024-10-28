# Create IAM policy for kubernetes tool external dns
resource "aws_iam_policy" "eks-external-dns-policy" {
  name        = coalesce(var.eks_external_dns_policy_name, "${var.project_prefix}-airflow-eks-external-dns-policy-${var.region}")
  path        = "/"
  description = "Policy used by external dns utility on eks cluster to manage Route53 Hosted zones."

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "route53:ChangeResourceRecordSets"
          ],
          "Resource" : [
            "arn:aws:route53:::hostedzone/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "route53:ListHostedZones",
            "route53:ListResourceRecordSets"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    }
  )
}

# Create IAM role for kubernetes tool external dns
resource "aws_iam_role" "eks-external-dns-role" {
  name        = coalesce(var.eks_external_dns_role_name, "${var.project_prefix}-airflow-eks-external-dns-role-${var.region}")
  description = "Role to be used by eks utility external dns to manage route 53 dns records."
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
  managed_policy_arns = [aws_iam_policy.eks-external-dns-policy.arn
  ]

}
