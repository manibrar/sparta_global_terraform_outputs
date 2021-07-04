output "db_ami" {
   description = "foo"
   value ="ami-01020378"
}

output "db_privateip" {
  description = "db instance private ip"
  value = "${aws_instance.db.private_ip}"
}
