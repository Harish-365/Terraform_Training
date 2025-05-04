data "aws_availability_zones" "available" {}
data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners = ["099720109477"]

filter {
  name = "name"
  values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
}
filter {
  name = "virtualization-type"
  values = ["hvm"]
}
}


resource "aws_instance" "Myfirstinstance" {
  ami = data.aws_ami.latest-ubuntu.id
  instance_type = "t2.micro"
 availability_zone = data.aws_availability_zones.available.names[5]
 vpc_security_group_ids = [aws_security_group.sg_custom_security.id]

provisioner "local-exec" {
  command = "echo ${aws_instance.Myfirstinstance.private_ip} >> myprivate_ip.txt"
  }

}
 output "public_ip" {
  value = aws_instance.Myfirstinstance.public_ip
 }
