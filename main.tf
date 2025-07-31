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

module "eks" {
  source                  = "git::https://github.com/teju-devopss/tf-module-eks.git"
  for_each                = var.eks


  env                     =  var.env
  project_name            = var.project_name
  component               = "eks"
  subnets_ids             = lookup(lookup(module.vpc,"main",null),"app_subnets_ids",null)
  node_groups             = lookup(each.value,"node_groups",null)

}

module "docdb" {
 source   = "git::https://github.com/teju-devopss/tf-module-docdb.git"

 for_each               = var.docdb
 engine                 = each.value["engine"]
 engine_version         = each.value["engine_version"]
 instance_class         = each.value["instance_class"]
 parameter_group_family = each.value["parameter_group_family"]
 instance_count         = each.value["instance_count"]

 subnets  = lookup(lookup(module.vpc, "main", null), "db_subnets_ids", null)
 vpc_id   = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
 sg_cidrs = lookup(lookup(var.vpc, "main", null), "app_subnets_cidr", null)

 project_name = var.project_name
 env          = var.env
 tags         = {}
 kms          = var.kms_key_id
}

module "elasticache" {
 source = "git::https://github.com/teju-devopss/tf-module-elasticache.git"

 for_each               = var.elasticache
 num_cache_nodes        = each.value["num_cache_nodes"]
 engine                 = each.value["engine"]
 engine_version         = each.value["engine_version"]
 node_type              = each.value["node_type"]
 parameter_group_family = each.value["parameter_group_family"]

 env  = var.env
 tags = {}
 kms  = var.kms_key_id
 project_name = var.project_name

 subnets  = lookup(lookup(module.vpc, "main", null), "db_subnets_ids", null)
 vpc_id   = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
 sg_cidrs = lookup(lookup(var.vpc, "main", null), "app_subnets_cidr", null)

}

module "rabbitmq" {
 source = "git::https://teju-devopss/tf-module-rabbitmq.git"

 for_each      = var.rabbitmq
 instance_type = each.value["instance_type"]

 env             = var.env
 tags            = {}
 kms             = var.kms_key_id
 bastion_cidrs   = var.bastion_cidrs
 route53_zone_id = var.zone_id
 project_name = var.project_name

 subnets  = lookup(lookup(module.vpc, "main", null), "db_subnets_ids", null)
 vpc_id   = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
 sg_cidrs = lookup(lookup(var.vpc, "main", null), "app_subnets_cidr", null)

}

module "rds" {
 source = "git::https://github.com/teju-devopss/tf-module-rds.git"

 for_each               = var.rds
 allocated_storage      = each.value["allocated_storage"]
 engine                 = each.value["engine"]
 engine_version         = each.value["engine_version"]
 instance_class         = each.value["instance_class"]
 parameter_group_family = each.value["parameter_group_family"]

 env  = var.env
 tags = {}
 kms  = var.kms_key_id
 project_name = var.project_name

 subnets  = lookup(lookup(module.vpc, "main", null), "db_subnets_ids", null)
 vpc_id   = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
 sg_cidrs = lookup(lookup(var.vpc, "main", null), "app_subnets_cidr", null)

}