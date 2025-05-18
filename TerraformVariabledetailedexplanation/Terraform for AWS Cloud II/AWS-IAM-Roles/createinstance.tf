resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.AWS_PUBLICKEY)
  
}

resource "aws_instance" "Myfirstinstance" {
    ami = lookup(var.AMIS, var.AWS_REGION)
    instance_type = "t2.micro"
    availability_zone = "us-east-1f"
    key_name = aws_key_pair.levelup_key.key_name
    iam_instance_profile = aws_iam_instance_profile.instanceprofile-s3.name

    tags = {
      Name = "Myfirstinstance"
    }
  
}

output "public_ip" {
    value = aws_instance.Myfirstinstance.public_ip
  
}