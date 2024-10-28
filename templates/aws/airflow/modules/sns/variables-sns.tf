variable "sns_topic_name" {
  type        = string
  description = "Name of SNS topic"
}

variable "sns_subscription_email_list" {
  type        = list(string)
  description = "List of email addresses that should subscribe to SNS topic for receiving alerts"
}
