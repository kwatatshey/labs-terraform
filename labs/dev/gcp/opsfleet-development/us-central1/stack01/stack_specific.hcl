locals {
  stack_name = reverse(split("/", get_terragrunt_dir()))[0]
}
