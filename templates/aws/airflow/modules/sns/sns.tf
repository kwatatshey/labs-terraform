# Create SNS topic for central monitoring alerts
resource "aws_sns_topic" "central_alerts_sns" {
  name              = var.sns_topic_name
  kms_master_key_id = "alias/aws/sns"
}


resource "aws_sns_topic_subscription" "sns_subscription_email" {
  for_each = toset(var.sns_subscription_email_list)

  topic_arn = aws_sns_topic.central_alerts_sns.arn
  protocol  = "email"
  endpoint  = each.key
}
