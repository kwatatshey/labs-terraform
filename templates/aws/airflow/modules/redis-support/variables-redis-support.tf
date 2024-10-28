variable "redis_sg_name" {
  type        = string
  description = "Name Redis security group"
}

variable "redis_sg_description" {
  type        = string
  description = "Description of Redis security group"
  default     = "Allow Redis port 6379 traffic"
}

variable "redis_subnet_group_name" {
  type        = string
  description = "Name Redis subnet group"
}

variable "redis_vpc_id" {
  type        = string
  description = "ID of target VPC"
}

variable "redis_subnets" {
  type        = list(any)
  description = "List of subnets for redis"
}
