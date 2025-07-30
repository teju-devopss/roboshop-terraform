env              = "dev"
project_name     = "expense"
kms_key_id       = "arn:aws:kms:us-east-1:522814736516:key/94568fc4-e087-46db-8d88-a6e69ed61d8e"
bastion_cidrs     = ["172.31.84.34/32"]  #workstation IP
prometheus_cidrs  = ["172.31.35.165/32"]
acm_arn          = "arn:aws:acm:us-east-1:522814736516:certificate/41696961-81dc-404c-a055-49b3e536cdba"
zone_id          = "Z07191123NJU9NTTKKZJ1"


vpc = {
  main = {
    vpc_cidr     = "10.10.0.0/21"
    public_subnets_cidr = ["10.10.0.0/25", "10.10.0.128/25"]
    web_subnets_cidr = ["10.10.1.0/25", "10.10.1.128/25"]
    app_subnets_cidr = ["10.10.2.0/25", "10.10.2.128/25"]
    db_subnets_cidr = ["10.10.3.0/25", "10.10.3.128/25"]
    az           = ["us-east-1a", "us-east-1b"]
  }
}
eks = {
  main = {
    node_groups = {
      n1 = {
        size = 1
        instance_types = ["t3.large"]
        capacity_type =SPOT

      }

    }

  }
}


