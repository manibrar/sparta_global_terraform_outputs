module "app_tier" {
  source = "./module/app_tier"
  vpc_id = "${module.app_tier.vpc_id}"
  name ="app-markson"
  app_ami_id ="ami-c2b8bfbb"
  db_ami_id ="ami-01020378"
  cidr_block ="10.0.0.0/16"
}
