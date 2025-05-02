resource "aws_key_pair" "levelup_key" {
  key_name = "levelup_key"
  public_key = file(var.AWS_PUBLICKEY)
}

resource "aws_instance" "Myfirstinstance" {
  ami = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.levelup_key.key_name
provisioner "file"{
  source = "INstalllNginix.sh"
  destination = "/tmp/INstalllNginix.sh"
}

provisioner "remote-exec"{
  inline = [
    "chmod +x /tmp/INstalllNginix.sh",
    "sudo sed -i -e 's/\r$//' /tmp/INstalllNginix.sh",
    "sudo /tmp/INstalllNginix.sh"
  ]
}

connection {
  host = coalesce(self.public_ip, self.private_ip)
  type = "ssh"
  user = var.INSTANCE_USERNAME
  private_key = file(var.AWS_PRIVATEKEY)
}
}