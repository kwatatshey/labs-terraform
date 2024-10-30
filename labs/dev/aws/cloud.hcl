locals {
  my_cloud      = basename(get_terragrunt_dir())
  my_account    = read_terragrunt_config(find_in_parent_folders("account.hcl")).locals.my_account
  my_account_id = read_terragrunt_config(find_in_parent_folders("account.hcl")).locals.my_account_id
  my_region     = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.my_region
  my_env        = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.my_env
}

generate "aws_provider" {
  path      = "aws_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.my_region}"
}
  EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    # disable_bucket_update = true
    bucket         = "deployment-states-terragrunt-${local.my_account}-${local.my_region}-${local.my_account_id}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.my_region}"
    encrypt        = true
    dynamodb_table = "deployment-locks-terragrunt-${local.my_account}-${local.my_region}-${local.my_account_id}"
    # skip_metadata_api_check = true

    s3_bucket_tags = {
      "account-name"        = "${local.my_account}"
      "env"                 = "${local.my_env}"
      "managed-by"          = "terragrunt"
      "data-classification" = "internal"
    }

    dynamodb_table_tags = {
      "account-name"        = "${local.my_account}"
      "env"                 = "${local.my_env}"
      "managed-by"          = "terragrunt"
      "data-classification" = "internal"
    }


  }
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket and use DynamoDB Table for locking.
