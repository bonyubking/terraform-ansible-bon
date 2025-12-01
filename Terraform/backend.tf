terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.6"
    }
  }

  backend "s3" {
    bucket         = "myce-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "ap-northeast-2"
    profile        = "myce"
    dynamodb_table = "myce-terraform-state-lock"
    encrypt        = true
  }
}