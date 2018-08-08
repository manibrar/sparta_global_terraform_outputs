output "vpc_id" {
description = "vpc of app"
  value = "${aws_vpc.app.id}"

}

output "db_ami" {
   description = "foo"
   value ="ami-01020378"
}
