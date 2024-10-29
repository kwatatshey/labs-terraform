include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "cloud_specific" {
  path = "../../../../../cloud_specific.hcl"
}

dependency "vpc" {
  config_path = "../../010_vpc_public"
  mock_outputs = {
    project_id    = "photoman-dev"
    network_name  = "mock-network-name"
    subnets_names = ["mock-subnet-name"]
    subnets_secondary_ranges = [
      [
        {
          range_name = "mock-range-name"
        },
        {
          range_name = "mock-range-name"
        }
      ]
    ]
  }
}

terraform {
  source = "../../../../../../../../templates/gcp/gke"
}

locals {
  environment_name           = include.root.locals.environment_specific_config.locals.environment
  cluster_parent_hosted_zone = include.root.locals.account_specific_config.locals.parent_zone_id
  region_name                = include.root.locals.region_specific_config.locals.region
  stack_name                 = include.root.locals.stack_specific_config.locals.stack_name
}

inputs = {
  cluster_name               = "${local.stack_name}-${local.environment_name}-gke"
  project_id                 = "${dependency.vpc.outputs.project_id}"
  network_name               = dependency.vpc.outputs.network_name
  zones                      = ["us-central1-a"] //zonal cluster - for free tier
  subnetwork                 = dependency.vpc.outputs.subnets_names[0]
  ip_range_pods              = dependency.vpc.outputs.subnets_secondary_ranges[0][0].range_name
  ip_range_services          = dependency.vpc.outputs.subnets_secondary_ranges[0][1].range_name
  cluster_parent_hosted_zone = local.cluster_parent_hosted_zone //. at the end is added inside the module
}

