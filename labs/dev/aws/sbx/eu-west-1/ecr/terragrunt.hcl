# terraform {
#   source = "${get_repo_root()}/templates/aws/ecr"
# }

terraform {
  source = "git::git@github.com:kwatatshey/labs-terraform-modules.git//templates/aws/ecr"
}


# For AWS provider & tfstate S3 backand
include {
  path = find_in_parent_folders("cloud.hcl")
}

locals {
  common_tags  = read_terragrunt_config(find_in_parent_folders("env.hcl")).inputs.common_tags
  repositories = fileexists("yamls/repositories.yaml") ? yamldecode(file("yamls/repositories.yaml")) : []
}

inputs = {
  repositories                   = local.repositories
  tags                           = local.common_tags
  days_to_remove_untagged_images = 3
  pr_image_count                 = 7
  max_image_count                = 50
}
