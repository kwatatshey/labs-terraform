variable "file_path" {
  type        = string
  description = "File path"
}

variable "function_name" {
  type        = string
  description = "Lambda function name"
}

variable "role_name" {
  type        = string
  description = "IAM role name for lambda"
}

variable "handler" {
  type        = string
  description = "Handler name"
}

variable "runtime" {
  type        = string
  description = "Lambda code runtime"
}

variable "publish" {
  description = "Whether to publish code or not"
  type        = bool
  default     = true
}

variable "vpc_config" {
  description = "A map of vpc config to apply to AWS resources"
  type        = map(string)
  default     = {}
}

variable "subnet_ids" {
  description = "List of subnet IDs within the VPC"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the Lambda function"
  type        = list(string)
}

variable "lambda_role_policy_arns" {
  description = "List of policy arns for lambda role"
  type        = list(string)
}

variable "sns_subscription_enabled" {
  description = "Set to true to enable SNS topic subscription for Lambda function"
  type        = bool
  default     = true
}

variable "custom_policy_enabled" {
  description = "Set to true to enable custom policy"
  type        = bool
  default     = true
}

variable "sns_lambda_trigger" {
  type        = string
  description = "sns lambda trigger"
}

variable "custom_policy_statement" {
  description = "Custom policy statement to be attached to lambda role"
  type        = list(map(string))
}

variable "custom_policy_name" {
  type        = string
  description = "custom policy name"
  default     = "custom-policy"
}

variable "lambda_additional_tags" {
  type    = map(string)
  default = {}
}