output "vpc_id" {
description = "vpc of app"
  value = "${aws_vpc.db.id}"

}

output "db_ami" {
   description = "foo"
   value ="ami-01020378"
}

output "db_privateip" {
  description = "db instance private ip"
  value = "${aws_instance.db.private_ip}"
}
