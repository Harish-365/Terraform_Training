provider "aws" {
    region = "us-east-1"
    }
  
resource "aws_instance" "Myec2" {
    ami = "ami-00045d6bafc77e3dc"
    instance_type = "t2.micro"
    count = 3
    
    tags = {
        Name = "my-cluster-${count.index}"
    }
}

resource "aws_iam_user" "group-of-users" {
    count = 3
    name = "user-${count.index}"
  
}