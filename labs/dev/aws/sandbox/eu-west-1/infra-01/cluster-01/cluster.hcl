locals {
  my_cluster   = basename(get_terragrunt_dir())
  cluster_name = "eks-${read_terragrunt_config(find_in_parent_folders("env.hcl")).locals.my_env}-${local.my_cluster}"
}
