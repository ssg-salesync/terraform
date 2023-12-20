terraform {
  backend "s3" {
    bucket         = "salesync-terraform-backend"
    key            = "terraform/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "salesync-terraform-state-lock"
    encrypt        = true
  }
}


module "vpc" {
  source     = "./modules/vpc"
  aws_region = var.region
  vpc_name   = var.vpc_name
  vpc_cidr   = var.vpc_cidr
}


module "sg" {
  source            = "./modules/sg"
  vpc_id            = module.vpc.vpc_id
  eks_cluster_sg_id = module.sg.eks_cluster_sg_id
  bastion_sg_id     = module.sg.bastion_sg_id
}


module "rds" {
  source      = "./modules/rds"
  db_password = var.db_password
  sg_id       = module.sg.rds_sg_id
  subnet_ids  = [module.vpc.private_subnet_ids[0], module.vpc.private_subnet_ids[1]]
}


module "iam" {
  source = "./modules/iam"
}


module "eks_cluster" {
  source            = "./modules/eks"
  eks_cluster_sg_id = module.sg.eks_cluster_sg_id
  eks_subnet_a_id   = module.vpc.public_subnet_ids[0]
  eks_subnet_c_id   = module.vpc.public_subnet_ids[1]
  cluster_role_arn  = module.iam.eks_cluster_role_arn
  nodes_role_arn    = module.iam.eks_node_role_arn
}


module "bastion" {
  source           = "./modules/ec2"
  bastion_sg_id    = module.sg.bastion_sg_id
  subnet_id        = module.vpc.public_subnet_ids[0]
  private_key_path = var.private_key_path
}
