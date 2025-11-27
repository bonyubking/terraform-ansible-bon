terraform {
  backend "s3" {
    bucket         = "myce-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "ap-northeast-2"
    profile        = "myce"
    dynamodb_table = "myce-terraform-state-lock"
    encrypt        = true
  }
}