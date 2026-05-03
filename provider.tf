terraform {
  required_version = ">= 1.10.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.100.0"
    }
  }

  backend "s3" {
    bucket = "eks-dev-terraform-state-bucket"
    key    = "eks/terraform.tfstate"
    region = "ap-south-1"
    # encrypt = true
    # dynamodb_table = "tf-aws-infra-terraform-locking"
    use_lockfile = true
    profile      = "demo-user1"
  }
}

provider "aws" {
  region  = "ap-south-1"
  profile = "demo-user1"
}