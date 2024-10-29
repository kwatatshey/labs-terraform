include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "cloud_specific" {
  path = "../../../../cloud_specific.hcl"
}

terraform {
  source = "tfr:///terraform-google-modules/network/google?version=7.2.0"
}

locals {
  environment  = include.root.locals.environment_specific_config.locals.environment
  project_id   = include.root.locals.account_specific_config.locals.project_id
  region       = include.root.locals.region_specific_config.locals.region
  network_name = "${include.root.locals.environment_specific_config.locals.environment}-${include.root.locals.account_specific_config.locals.project_id}-vpc"
}

inputs = {
  project_id   = "${local.project_id}"
  network_name = "${local.network_name}"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "${local.network_name}-subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = "${local.region}"
    },
    {
      subnet_name      = "${local.network_name}-subnet-02"
      subnet_ip        = "10.10.20.0/24"
      subnet_region    = "${local.region}"
      subnet_flow_logs = "false"
      description      = "This subnet has a description"
    },
    {
      subnet_name      = "${local.network_name}-subnet-03"
      subnet_ip        = "10.10.30.0/24"
      subnet_region    = "${local.region}"
      subnet_flow_logs = "false"
    }
  ]

  secondary_ranges = {
    "${local.network_name}-subnet-01" = [
      {
        range_name    = "${local.network_name}-subnet-01-secondary-pods-01"
        ip_cidr_range = "192.168.10.0/24"
      }
      ,
      {
        range_name    = "${local.network_name}-subnet-01-secondary-services-02"
        ip_cidr_range = "192.168.11.0/24"
      }
    ]

    "${local.network_name}-subnet-02" = [
      {
        range_name    = "${local.network_name}-subnet-02-secondary-01"
        ip_cidr_range = "192.168.20.0/24"
      }
    ]

    "${local.network_name}-subnet-03" = [
      {
        range_name    = "${local.network_name}-subnet-03-secondary-01"
        ip_cidr_range = "192.168.30.0/24"
      }
    ]
  }

  routes = [
    {
      name              = "${local.network_name}-egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    }
  ]

}