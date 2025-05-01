resource "aws_instance" "Myfirstinstance" {
  ami = "ami-00045d6bafc77e3dc"
  instance_type = "t2.micro"

  security_groups = "${var.Security_Groups}"
}