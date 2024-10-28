variable "common_tags" {
  description = "Common tags to be assigned across infrastructure pieces"
  type        = map(string)
}

variable "prometheus_agent_roles" {
  type        = list(string)
  description = "List of agent prometheus roles that can remote write to central."
}

variable "sns_subscription_email_list" {
  type        = list(string)
  description = "List of email addresses that should subscribe to SNS topic for receiving alerts"
}

variable "subnet_ids" {
  description = "List of subnet IDs within the VPC"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the Lambda function"
  type        = list(string)
}

variable "lambda_moogsoft_policy_arns" {
  type        = list(string)
  description = "List of policy arns for lambda"
}

variable "custom_policy_statement" {
  description = "Custom policy statement to be attached to lambda role"
  type        = list(map(string))
}

variable "lambda_moogsoft_additional_tags" {
  type    = map(string)
  default = {}
}