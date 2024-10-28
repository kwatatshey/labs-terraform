# Required AWS provider version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.55.0"
    }
  }

  # Setup S3 and DynamoDB backend. Both S3 bucket and DynamoDB are created as a prerequisite during AWS account setup. Backend key must be unique in given AWS account.
  backend "s3" {
    bucket         = "aparflow-dev-tf-states"
    key            = "aparflow-airflowfdna-terraform-sbx-eu-west-1"
    region         = "us-east-1"
    profile        = "default"
    encrypt        = true
    dynamodb_table = "aparflow-tf-locks"
  }

}

# Setup AWS provider with default tags as requested by Merck policy
provider "aws" {
  region = var.region
  ignore_tags {
    keys = ["Contact", "CoreInfraTag-BackupCopyToBunker"]
  }
  default_tags {
    tags = {
      Environment        = var.common_tags.Environment
      Application        = var.common_tags.Application
      Costcenter         = var.common_tags.Costcenter
      Division           = var.common_tags.Division
      DataClassification = var.common_tags.DataClassification
      Consumer           = var.common_tags.Consumer
      Service            = var.common_tags.Service
    }
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
    }
  }
}