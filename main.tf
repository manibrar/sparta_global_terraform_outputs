provider "aws" {
  region  = "eu-west-1"
}

module "app_tier" {
  source = "./module/app_tier"
  vpc_id = "${module.app_tier.vpc_id}"
  name ="app-manvir"
  app_ami_id ="${module.app_tier.app_ami}"
  db_ami_id ="${module.app_tier.db_ami}"
  cidr_block ="10.0.0.0/16"
}

module "db_tier" {
  source = "./module/db_tier"
  vpc_id = "${module.db_tier.vpc_id}"
  name ="db-manvir"
  app_ami_id ="${module.db_tier.db_ami}"
  db_ami_id ="${module.db_tier.db_ami}"
  cidr_block ="10.0.0.0/16"
}
