provider "aws" {
  region = "ap-northeast-2"
}


resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enalbe_dns_support = true
  enalbe_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}


resource "aws_route_table_association" "public_subnet_a_association" {
  subnet_id = module.subnet_public_a.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_route_table_association" "public_subnet_c_association" {
  subnet_id = module.subnet_public_c.id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_eip" "bastion_eip" {
  instance = var.instance_id
}


module "subnet_public_a" {
    source = "./subnet"
    az = "ap-northeast-2a"
    index = 1
    vpc_id = aws_vpc.main.id
    vpc_cidr_block = var.vpc_cidr_block
    public_ip = true
}


module "subnet_private_a" {
    source = "./subnet"
    az = "ap-northeast-2a"
    index = 2
    vpc_id = aws_vpc.main.id
    vp_cidr_block = var.vpc_cidr_block
    public_ip = false
}


module "subnet_public_c" {
    source = "./subnet"
    az = "ap-northeast-2a"
    index = 3
    vpc_id = aws_vpc.main.id
    vpc_cidr_block = var.vpc_cidr_block
    public_ip = true
}


module "subnet_private_c" {
    source = "./subnet"
    az = "ap-northeast-2a"
    index = 4
    vpc_id = aws_vpc.main.id
    vpc_cidr_block = var.vpc_cidr_block
    public_ip = false
}


output "vpc_id" {
  value = aws_vpc.main.id
}


output "subnet_public_a_id" {
  value = module.subnet_public_a.id
}


output "subnet_private_a_id" {
  value = module.subnet_private_a.id
}


output "subnet_public_a_id" {
  value = module.subnet_public_c.id
}


output "subnet_private_a_id" {
  value = module.subnet_private_c.id
}