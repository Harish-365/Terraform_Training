resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.AWS_PUBLICKEY) ## create key uisng ssh-keygen -f levelup_key
}

resource "aws_instance" "Myfirstinstance" {
    ami = lookup(var.AMIS, var.AWS_REGION)
    instance_type = "t2.micro"
    key_name      = aws_key_pair.levelup_key.key_name 
    

    tags = {
        Name = "Myfirstinstance"
    }
}

#EBS resource creation for the secondary volume

resource "aws_ebs_volume" "ebs-volume" {
    size = 10
    availability_zone = "us-east-1f"
    type = "gp2"

    tags = {
      Name = "secondary-ebs-volume"
    }
}

#EBS volume attachment to the ec2

resource "aws_volume_attachment" "ebs-volume-1" {
    instance_id = aws_instance.Myfirstinstance.id
    volume_id = aws_ebs_volume.ebs-volume.id
    device_name = "/dev/xvdh"
  
}