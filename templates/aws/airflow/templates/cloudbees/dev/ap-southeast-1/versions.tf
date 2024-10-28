# Required AWS provider version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.61"
    }
  }
  # Setup S3 and DynamoDB backend. Both S3 bucket and DynamoDB are created as a prerequisite during AWS account setup. Backend key must be unique in given AWS account.
  backend "s3" {
  }
}

# Setup AWS provider with default tags as requested by Merck policy. Resources will be deployed to this region.
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment        = var.common_tags.Environment
      Application        = var.common_tags.Application
      Costcenter         = var.common_tags.Costcenter
      Division           = var.common_tags.Division
      DataClassification = var.common_tags.DataClassification
      Consumer           = var.common_tags.Consumer
      Service            = var.common_tags.Service
      Project            = var.common_tags.Project
    }
  }
  assume_role {
    role_arn = "arn:aws:iam::331013986936:role/airflow-eks-deployment-role"
  }
}

# AWS provider with different region that will be used for cross-region replication
provider "aws" {
  region = var.backup_region
  alias  = "replica"
  default_tags {
    tags = {
      Environment        = var.common_tags.Environment
      Application        = var.common_tags.Application
      Costcenter         = var.common_tags.Costcenter
      Division           = var.common_tags.Division
      DataClassification = var.common_tags.DataClassification
      Consumer           = var.common_tags.Consumer
      Service            = var.common_tags.Service
      Project            = var.common_tags.Project
    }
  }
  assume_role {
    role_arn = "arn:aws:iam::331013986936:role/airflow-eks-deployment-role"
  }
}

# AWS provider with static us-east-1 region. In us-east-1 region there will be AWS secretsmanager secret that will have sensitive values that are common across instances.
provider "aws" {
  region = "us-east-1"
  alias  = "secrets"
  assume_role {
    role_arn = "arn:aws:iam::331013986936:role/airflow-eks-deployment-role"
  }
}
