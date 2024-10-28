variable "route53_sg_name" {
  type        = string
  description = "Name route53 security group"
}

variable "route53_vpc_id" {
  type        = string
  description = "ID of target VPC"
}

variable "route53_endpoint_name" {
  type        = string
  description = "Name route53 inbound endpoint"
}

variable "route53_endpoint_subnets" {
  type        = list(any)
  description = "List of subnets where route53 endpoint will be deployed"
}

variable "route53_hosted_zone_name" {
  type        = string
  description = "Hosted zone name for this cluster"
}
