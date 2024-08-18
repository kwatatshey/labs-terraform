# get all available AZs in our region
data "aws_availability_zones" "available_azs" {
  state = "available"
  filter {
    name   = "zone-name"
    values = var.azs
  }
}

# reserve Elastic IP to be used in our NAT gateway
resource "aws_eip" "nat_gw_elastic_ip" {
  domain = "vpc"

  tags = {
    Name = var.eip_name
  }
}

# create VPC using the official AWS module
#tfsec:ignore:aws-ec2-no-excessive-port-access
#tfsec:ignore:aws-ec2-no-public-ingress-acl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = var.vpc_name
  cidr = var.main_network_block
  azs  = data.aws_availability_zones.available_azs.names

  #   private_subnets = [
  #     # this loop will create a one-line list as ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20", ...]
  #     # with a length depending on how many Zones are available
  #     for zone_id in data.aws_availability_zones.available_azs.zone_ids :
  #     cidrsubnet(var.main_network_block, var.subnet_prefix_extension, index(data.aws_availability_zones.available_azs.zone_ids, zone_id))
  #   ]

  #   public_subnets = [
  #     # this loop will create a one-line list as ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20", ...]
  #     # with a length depending on how many Zones are available
  #     # there is a zone Offset variable, to make sure no collisions are present with private subnet blocks
  #     for zone_id in data.aws_availability_zones.available_azs.zone_ids :
  #     cidrsubnet(var.main_network_block, var.subnet_prefix_extension, index(data.aws_availability_zones.available_azs.zone_ids, zone_id) + var.zone_offset)
  #   ]

  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  database_subnets = var.database_subnets
  # enable single NAT Gateway to save some money
  # WARNING: this could create a single point of failure, since we are creating a NAT Gateway in one AZ only
  # feel free to change these options if you need to ensure full Availability without the need of running 'terraform apply'
  # reference: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.44.0#nat-gateway-scenarios
  create_igw              = true
  enable_vpn_gateway      = false
  enable_nat_gateway      = true
  single_nat_gateway      = true
  one_nat_gateway_per_az  = false
  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true
  reuse_nat_ips           = true
  external_nat_ip_ids     = [aws_eip.nat_gw_elastic_ip.id]


  # add VPC/Subnet tags required by EKS
  tags = var.tags

  public_subnet_tags = {
    "PublicSubnet" = "true"
    # "kubernetes.io/role/elb"
    "kubernetes.io/role/elb" = 1
    # "karpenter.sh/discovery" = local.public
  }
  private_subnet_tags = {
    "PrivateSubnet"                   = "true"
    "kubernetes.io/role/internal-elb" = 1
    # Tags subnets for Karpenter auto-discovery
    # "karpenter.sh/discovery" = local.private

  }
}

locals {
  private = "private"
  public  = "public"

}
