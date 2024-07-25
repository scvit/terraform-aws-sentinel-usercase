terraform {
  cloud {
    organization = "great-stone-biz"
    workspaces {
      name = "policy_iam_password"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}