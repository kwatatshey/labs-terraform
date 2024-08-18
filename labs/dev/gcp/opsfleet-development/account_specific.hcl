locals {
  parent_zone_id = "dev.google.dev.opsfleet.com"
  project_id = reverse(split("/", get_terragrunt_dir()))[0]
}
