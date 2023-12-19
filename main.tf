terraform {
  backend "s3" {
    bucket = "salesync-terraform-backend"
    key = "terraform/backend"
    region = "ap-northeast-2"
    dynamodb_table = "salesync-terraform-state-lock"
    encrypt = true
  }
}


module "vpc" {
  source     = "./modules/vpc"
  aws_region = var.region
  vpc_name   = var.vpc_name
  vpc_cidr   = var.vpc_cidr
}


module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}


module "rds" {
  source = "./modules/rds"
  db_password = var.db_password
  sg_id = module.sg.rds_sg_id
  subnet_ids = [module.vpc.private_subnet_ids[0], module.vpc.private_subnet_ids[1]]
}
