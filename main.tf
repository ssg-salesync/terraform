terraform {
  backend "s3" {
    bucket = "salesync-terraform-backend"
    key = "terraform/backend"
    region = "ap-northeast-2"
  }
}