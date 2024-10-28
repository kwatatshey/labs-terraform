# Create security group to allow access on port 53
resource "aws_security_group" "route53_sg" {
  name        = var.route53_sg_name
  description = "Allow DNS port 53 traffic"
  vpc_id      = var.route53_vpc_id

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Route 53 resolver inbound endpoint to allow DNS resolution forwarding from Merck to AWS
resource "aws_route53_resolver_endpoint" "route53_inbound_endpoint" {
  name      = var.route53_endpoint_name
  direction = "INBOUND"

  security_group_ids = [aws_security_group.route53_sg.id]

  dynamic "ip_address" {
    for_each = var.route53_endpoint_subnets
    iterator = subnet

    content {
      subnet_id = subnet.value
    }
  }

}

# Create Route53 Hosted zone
resource "aws_route53_zone" "route53_hosted_zone" {
  name    = var.route53_hosted_zone_name
  comment = "Hosted zone to manage Airflow on EKS DNS rules"

  vpc {
    vpc_id = var.route53_vpc_id
  }
}

