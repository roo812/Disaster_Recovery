module "vpc_primary" {
  source     = "./modules/vpc"
  region     = var.primary_region
  vpc_cidr   = var.vpc_cidr_primary
  azs        = var.azs_primary
  providers = {
    aws = aws.primary
  }
}

module "vpc_secondary" {
  source     = "./modules/vpc"
  region     = var.secondary_region
  vpc_cidr   = var.vpc_cidr_secondary
  azs        = var.azs_secondary
  providers = {
    aws = aws.secondary
  }
}

module "aurora" {
  source            = "./modules/aurora"
  primary_region    = var.primary_region
  secondary_region  = var.secondary_region
  primary_vpc_id    = module.vpc_primary.vpc_id
  primary_subnets   = module.vpc_primary.private_subnets
  primary_db_sg_id  = module.vpc_primary.db_sg_id
  secondary_vpc_id  = module.vpc_secondary.vpc_id
  secondary_subnets = module.vpc_secondary.private_subnets
  secondary_db_sg_id = module.vpc_secondary.db_sg_id
  db_username       = var.db_username
  db_password       = var.db_password
  providers = {
    aws.primary   = aws.primary
    aws.secondary = aws.secondary
  }
}

module "asg_primary" {

  source           = "./modules/asg"
  vpc_id           = module.vpc_primary.vpc_id
  subnets          = module.vpc_primary.public_subnets
  alb_tg_arn       = module.alb_primary.target_group_arn
  ec2_sg_id        = module.vpc_primary.ec2_sg_id
  instance_role    = module.iam.ec2_role_arn
  app_bucket       = var.app_bucket
  db_endpoint      = module.aurora.primary_endpoint
  db_username      = var.db_username
  db_password      = var.db_password
  providers = {
    aws = aws.primary
  }

}

module "asg_secondary" {

  source           = "./modules/asg"
  vpc_id           = module.vpc_secondary.vpc_id
  subnets          = module.vpc_secondary.public_subnets
  alb_tg_arn       = module.alb_secondary.target_group_arn
  ec2_sg_id        = module.vpc_secondary.ec2_sg_id
  instance_role    = module.iam.ec2_role_arn
  app_bucket       = var.app_bucket
  db_endpoint      = module.aurora.secondary_endpoint
  db_username      = var.db_username
  db_password      = var.db_password
  providers = {
    aws = aws.secondary
  }
  
}

module "alb_primary" {
  source      = "./modules/alb"
  vpc_id      = module.vpc_primary.vpc_id
  
  subnets     = module.vpc_primary.public_subnets
  sg_id       = module.vpc_primary.alb_sg_id
  providers = {
    aws = aws.primary
  }
}

module "alb_secondary" {
  source      = "./modules/alb"
  vpc_id      = module.vpc_secondary.vpc_id
  subnets     = module.vpc_secondary.public_subnets
  sg_id       = module.vpc_secondary.alb_sg_id
  providers = {
    aws = aws.secondary
  }
}


module "iam" {
  source         = "./modules/iam"
  app_bucket     = var.app_bucket
}


module "cloudwatch_sns" {
  source            = "./modules/cloudwatch_sns"
  sns_email         = var.sns_email
  aurora_cluster_id = module.aurora.global_cluster_id
  # s3_bucket         = module.s3_state.state_bucket
  providers = {
    aws.primary   = aws.primary
    aws.secondary = aws.secondary
  }
}

module "route53" {
  source             = "./modules/route53"
  domain_name        = var.domain_name
  primary_alb_dns    = module.alb_primary.alb_dns
  primary_alb_zone   = module.alb_primary.alb_zone_id
  secondary_alb_dns  = module.alb_secondary.alb_dns
  secondary_alb_zone = module.alb_secondary.alb_zone_id
  providers = {
    aws = aws.primary  # Route53 is global, but use primary
  }
}