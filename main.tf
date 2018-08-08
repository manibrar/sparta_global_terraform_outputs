module "app_tier" {
  source = "./module/app_tier"
  vpc_id = "${module.app_tier.vpc_id}"
  name ="app-markson"
  app_ami_id ="${module.app_tier.app_ami}"
  db_ami_id ="${module.app_tier.db_ami}"
  cidr_block ="10.0.0.0/16"
}
