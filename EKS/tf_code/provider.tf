terraform {
  cloud {
    organization = "great-stone-biz"
    workspaces {
      name = "policy_eks_security"
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