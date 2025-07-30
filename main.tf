module "vpc" {
  source              = "git::https://github.com/teju-devopss/tf-module-vpc.git"
  for_each            = var.vpc
  vpc_cidr            = lookup(each.value, "vpc_cidr", null)
  public_subnets_cidr = lookup(each.value, "public_subnets_cidr", null)
  web_subnets_cidr    = lookup(each.value, "web_subnets_cidr", null)
  app_subnets_cidr    = lookup(each.value, "app_subnets_cidr", null)
  db_subnets_cidr     = lookup(each.value, "db_subnets_cidr", null)
  az                   = lookup(each.value, "az", null)

  env                  = var.env
  project_name         = var.project_name
}

# module "rds" {
#   source = "./modules/rds"
#
#   allocated_storage = var.rds_allocated_storage
#   dbname            = var.rds_dbname
#   engine            = var.rds_engine
#   engine_version    = var.rds_engine_version
#   family            = var.rds_family
#   instance_class    = var.rds_instance_class
#
#   env          = var.env
#   project_name = var.project_name
#   kms_key_id   = var.kms_key_id
#
#   subnet_ids     = module.vpc.app_subnets_ids
#   vpc_id         = module.vpc.vpc_id
#   sg_cidr_blocks = var.app_subnets_cidr
# }
#
# module "backend" {
#   depends_on         = [module.rds] #after rds it runs so we use depends on keyword
#   source              = "./modules/app"
#   env                 = var.env
#   project_name        = var.project_name
#   component           = "backend"
#   app_port            = var.backend_app_port
#   instance_capacity   = var.backend_instance_capacity
#   instance_type       = var.backend_instance_type
#   bastion_cidrs       = var.bastion_cidrs
#   sg_cidr_blocks      = var.app_subnets_cidr           # who can access backend
#   vpc_zone_identifier = module.vpc.app_subnets_ids     # where backend instances will run
#   vpc_id              = module.vpc.vpc_id
#   parameters          =["arn:aws:ssm:us-east-1:522814736516:parameter/${var.env}.${var.project_name}.rds.*", "arn:aws:ssm:us-east-1:522814736516:parameter/newrelic.*"]
#   kms                 = var.kms_key_id
#   prometheus_cidrs    = var.prometheus_cidrs
# }
#
# module "frontend" {
#   source              = "./modules/app"
#   env                 = var.env
#   project_name        = var.project_name
#   component           = "frontend"
#   app_port            = var.frontend_app_port
#   instance_capacity   = var.frontend_instance_capacity
#   instance_type       = var.frontend_instance_type
#   bastion_cidrs       = var.bastion_cidrs
#   sg_cidr_blocks      = var.public_subnets_cidr        # who can access frontend (usually 0.0.0.0/0)
#   vpc_zone_identifier = module.vpc.web_subnets_ids     # where frontend instances will run
#   vpc_id              = module.vpc.vpc_id
#   parameters          = ["arn:aws:ssm:us-east-1:522814736516:parameter/newrelic.*"]
#   kms                 = var.kms_key_id
#   prometheus_cidrs    = var.prometheus_cidrs
# }
#
#
# module "public-alb" {
#   source = "./modules/alb"
#
#   alb_name       = "public"
#   internal       = false
#   sg_cidr_blocks = ["0.0.0.0/0"]
#   dns_name       = "frontend"
#
#   project_name = var.project_name
#   env          = var.env
#   acm_arn      = var.acm_arn
#   zone_id      = var.zone_id
#
#   subnets          = module.vpc.public_subnets_ids
#   vpc_id           = module.vpc.vpc_id
#   target_group_arn = module.frontend.target_group_arn
#
# }
#
# module "private-alb" {
#   source = "./modules/alb"
#
#   alb_name = "private"
#   internal = true
#   dns_name = "backend"
#
#   sg_cidr_blocks = var.web_subnets_cidr
#   project_name   = var.project_name
#   env            = var.env
#   acm_arn        = var.acm_arn
#   zone_id        = var.zone_id
#
#   subnets          = module.vpc.app_subnets_ids
#   vpc_id           = module.vpc.vpc_id
#   target_group_arn = module.backend.target_group_arn
#
# }