dependency "vpc" {
  config_path  = "../vpc"
  skip_outputs = true
}

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

# terraform {
#     source = "tfr:///terraform-aws-modules/vpc/aws?version=3.14.2"
# }

inputs = {
  environment = local.environment_specific_config.locals.environment
  tags = {
    Terragrunt  = "true"
    Environment = "${local.environment}"
  }
}
