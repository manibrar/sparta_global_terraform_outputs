provider "aws" {
  region  = "eu-west-1"
}

module "app_tier" {
  source = "./module/app_tier"
  vpc_id = "${module.app_tier.vpc_id}"
  name ="app-manvir"
  app_ami_id ="${module.app_tier.app_ami}"
  cidr_block ="10.0.0.0/16"
  privateip = "${module.db_tier.db_privateip}"
}

module "db_tier" {
  source = "./module/db_tier"
  vpc_id = "${module.db_tier.vpc_id}"
  name ="db-manvir"
  db_ami_id ="${module.db_tier.db_ami}"
  cidr_block ="10.0.0.0/16"
  app_sec = "${module.app_tier.app_sec}"
}
