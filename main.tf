# VPC Module
module "vpc" {
  source      = "./modules/vpc"
  vpc_cidr    = var.vpc_cidr
  public_cidr = var.public_cidr
  private_cidr = var.private_cidr
  availability_zone = var.availability_zone
}

# ECS Module
module "ecs" {
  source       = "./modules/ecs"
  cluster_name = var.cluster_name
  vpc_id       = module.vpc.vpc_id
}

# RDS Module
module "rds" {
  source              = "./modules/rds"
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
  private_subnet_ids  = [module.vpc.private_subnet_id]
}

# Redis Module
module "redis" {
  source             = "./modules/redis"
  cluster_id         = var.redis_cluster_id
  private_subnet_ids = [module.vpc.private_subnet_id]
}

# EFS Module
module "efs" {
  source             = "./modules/efs"
  creation_token     = var.efs_creation_token
  private_subnet_ids = [module.vpc.private_subnet_id]
  security_group_id  = module.ecs.security_group_id
}
