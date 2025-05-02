resource "aws_instance" "Myfirstinstance" {
  ami = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"

  security_groups = "${var.Security_Groups}"
}