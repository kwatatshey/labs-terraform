# Required AWS provider version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.13.1"
    }
  }

  # Setup S3 and DynamoDB backend. Both S3 bucket and DynamoDB are created as a prerequisite during AWS account setup. Backend key must be unique in given AWS account.
  backend "s3" {}

}

# Setup AWS provider with default tags as requested by Merck policy
provider "aws" {
  region = var.region
  ignore_tags {
    keys = ["CoreInfraTag-Backup", "CoreInfraTag-BackupCopyToBunker", "CoreInfraTag-BackupPolicy", "Contact"]
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
  assume_role {
    role_arn = "arn:aws:iam::806735670197:role/airflow-eks-deployment-role"
  }
}
