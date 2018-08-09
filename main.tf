provider "aws" {
  region  = "eu-west-1"
}

# create a vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "Manvir-main"
  }
}

# create an a record

resource "aws_route53_record" "www" {
  zone_id = "Z3CCIZELFLJ3SC"
  name    = "manvir.spartaglobal.education"
  type    = "A"
  ttl     = "300"
  records = ["${aws_elb.Manvir_elb.id}"]
}


# create an elb
resource "aws_elb" "Manvir_elb" {
  name               = "manvir-terraform-elb"
  subnets = ["module.app_tier.app_subnet"]

  access_logs {
    bucket        = "manvir-elb"
    interval      = 60
  }

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 8000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = ["${module.app_tier.app_ami}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
    tags {
      Name = "manvir-terraform-elb"
    }
  }

module "app_tier" {
  source = "./module/app_tier"
  vpc_id = "${aws_vpc.main.id}"
  name ="app-manvir"
  app_ami_id ="${module.app_tier.app_ami}"
  cidr_block ="10.0.0.0/16"
  privateip = "${module.db_tier.db_privateip}"
}

module "db_tier" {
  source = "./module/db_tier"
  vpc_id = "${aws_vpc.main.id}"
  name ="db-manvir"
  db_ami_id ="${module.db_tier.db_ami}"
  cidr_block ="10.0.0.0/16"
  app_sec = "${module.app_tier.app_sec}"
}
