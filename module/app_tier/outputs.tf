output "app_ami" {
   description = "foo"
   value ="ami-c2b8bfbb"
}

output "app_sec" {
   description = "foo"
   value ="${aws_security_group.app.id}"
}

output "app_subnet" {
  description ="app subnet"
  value = "${aws_subnet.app.id}"
}

output "app_id" {
  description = "app id"
  value = "${aws_instance.app.id}"
}
