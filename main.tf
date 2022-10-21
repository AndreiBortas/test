terraform {
  backend "s3" {
    bucket         = "terraform-tfstate-andreibortas5712"
    key            = "terraform.tfstate"
    dynamodb_table = "lock-state"
    region         = "us-west-2"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.38"
    }
  }

  required_version = ">= 0.15"
}

provider "aws" {
  region = "us-west-2"
}
