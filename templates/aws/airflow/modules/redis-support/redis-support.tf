# Pull info about default security group
data "aws_security_group" "default_sg_id" {
  name   = "default"
  vpc_id = var.redis_vpc_id
}

# Create security group for Redis to allow access on port 6379
resource "aws_security_group" "redis_sg" {
  name        = var.redis_sg_name
  description = var.redis_sg_description
  vpc_id      = var.redis_vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [data.aws_security_group.default_sg_id.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create subnet group for Redis
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name        = var.redis_subnet_group_name
  subnet_ids  = var.redis_subnets
  description = "Subnet group for redis cluster for Airflow on EKS"
}
