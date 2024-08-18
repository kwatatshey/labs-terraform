include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  terraform_config = read_terragrunt_config(find_in_parent_folders("terraform_config.hcl"))
  tag              = local.terraform_config.locals.tag

  environment_specific_config = read_terragrunt_config(find_in_parent_folders("environment_specific.hcl"))
  environment                 = local.environment_specific_config.locals.environment

  module_vars  = read_terragrunt_config("module_vars.hcl")
  module_order = local.module_vars.locals.module_order
  module_name  = local.module_vars.locals.module_name
}

terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=3.14.2"
}

//create only public env
//create private and public env

inputs = {
  name                = "${local.environment}-vpc" //env-acount-region-vpc
  cidr                = "10.0.0.0/16"
  azs                 = ["eu-west-2a", "eu-west-2b", "eu-west-2c"] //not hardcoded
  private_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_tags = { "PrivateSubnet" = "true" }
  public_subnets      = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  public_subnet_tags  = { "PublicSubnet" = "true" }

  enable_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {
    Terragrunt  = "true"
    Environment = "${local.environment}"
  }
}
