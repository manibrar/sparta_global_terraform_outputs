output "vpc_id" {
description = "vpc of app"
  value = "${aws_vpc.app.id}"

}

output "app_ami" {
   description = "foo"
   value ="ami-c2b8bfbb"
}

output "db_ami" {
   description = "foo"
   value ="ami-01020378"
}
