terraform {
  backend "s3" {
    bucket         = "fs-terraform-app-state"
    key            = "fs-terraform-app.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "fs-wm-state"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.44.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.1.0"
    }
    archive = {
      source = "hashicorp/archive"
      version = "2.2.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

# Interpolation syntax : adjust local prefix by workspace
locals {
  prefix = terraform.workspace

  acc_id = data.aws_caller_identity.current.account_id

  region_id = data.aws_region.current.name

  # add common_tags to be applied to all resources in this project
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    Owner       = var.contact
    ManagedBy   = "Terraform"

  }
}

# retrive the current region
data "aws_region" "current" {}

# retrive the current account caller id
data "aws_caller_identity" "current" {}