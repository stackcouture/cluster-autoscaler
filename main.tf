module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  env                  = var.env
  instance_tenancy     = var.instance_tenancy
  vpc_name             = var.vpc_name
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
}

module "igw" {
  source       = "./modules/igw"
  vpc_id       = module.vpc.vpc_id
  igw_name     = var.igw_name
  env          = var.env
  cluster-name = var.cluster-name
}

module "subnets" {
  source                = "./modules/subnets"
  vpc_id                = module.vpc.vpc_id
  env                   = var.env
  cluster-name          = var.cluster-name
  pub-sub-name          = var.pub-sub-name
  pub-subnet-count      = var.pub-subnet-count
  pub-cidr-block        = var.pub-cidr-block
  pub-availability-zone = var.pub-availability-zone

  pri-sub-name          = var.pri-sub-name
  pri-subnet-count      = var.pri-subnet-count
  pri-cidr-block        = var.pri-cidr-block
  pri-availability-zone = var.pri-availability-zone
}