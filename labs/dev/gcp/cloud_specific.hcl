locals{
  account_specific_config = read_terragrunt_config(find_in_parent_folders("account_specific.hcl"))
  region_specific = read_terragrunt_config(find_in_parent_folders("region_specific.hcl"))
}


# project_id = opsfleet-development

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "google" {
  project = "${local.account_specific_config.locals.project_id}"
  region  = "${local.region_specific.locals.region}"
  }
  EOF
}

remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    project  = "${local.account_specific_config.locals.project_id}"
    location = "us"
    bucket   = "${local.account_specific_config.locals.project_id}-tf-state"
    prefix   = "${basename(get_parent_terragrunt_dir())}/${path_relative_to_include()}"
  }
}