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