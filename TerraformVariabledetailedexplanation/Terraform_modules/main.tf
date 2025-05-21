provider "aws" {
    region = "us-east-1"
  
}

module "My-first-module" {
    source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance.git"
    name = "My-first-module"
    ami = "ami-00045d6bafc77e3dc"
    instance_type = "t2.micro"
    subnet_id = "subnet-05c89a7f34226dece"

    tags = {
        Terraform = "true"
        Environment = "dev"
        machine = "Harish"

    }
}