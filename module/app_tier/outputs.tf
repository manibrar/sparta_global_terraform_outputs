output "vpc_id" {
description = "vpc of app"
  value = "${aws_vpc.app.id}"

}

output "app_ami" {
   description = "foo"
   value ="ami-c2b8bfbb"
}

output "app_sec" {
   description = "foo"
   value ="${aws_security_group.app.id}"
}
