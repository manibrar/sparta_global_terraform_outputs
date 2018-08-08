# create a vpc
resource "aws_vpc" "app" {
  cidr_block = "${var.cidr_block}"

  tags {
    Name = "${var.name}"
  }
}


# internet gateway
resource "aws_internet_gateway" "app" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.name}"
  }
}

# APP
# create a subnet
resource "aws_subnet" "app" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "eu-west-1a"
  tags {
    Name = "${var.name}"
  }
}

# security
resource "aws_security_group" "app"  {
  name = "${var.name}"
  description = "${var.name} access"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = "80"
    to_port         = "80"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name}"
  }
}

resource "aws_network_acl" "app" {
  vpc_id = "${var.vpc_id}"

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # EPHEMERAL PORTS

  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  subnet_ids   = ["${aws_subnet.app.id}"]

  tags {
    Name = "${var.name}"
  }
}

# public route table
resource "aws_route_table" "app" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.app.id}"
  }

  tags {
    Name = "${var.name}-public"
  }
}

resource "aws_route_table_association" "app" {
  subnet_id      = "${aws_subnet.app.id}"
  route_table_id = "${aws_route_table.app.id}"
}

# load the init template
data "template_file" "app_init" {
   template = "${file("./scripts/app/init.sh.tpl")}"
   vars {
      db_host="mongodb://${var.privateip}:27017/posts"
   }
}

# launch an instance
resource "aws_instance" "app" {
  ami           = "${var.app_ami_id}"
  subnet_id     = "${aws_subnet.app.id}"
  vpc_security_group_ids = ["${aws_security_group.app.id}"]
  user_data = "${data.template_file.app_init.rendered}"
  instance_type = "t2.micro"
  tags {
      Name = "${var.name}"
  }
}
