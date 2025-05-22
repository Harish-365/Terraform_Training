provider "aws" {
    region = "us-east-1"
  
}

module "My-ec2-instance" {
    source = "github.com/terraform-aws-modules/terraform-aws-ec2-instance.git"

    name = "my-cluster"
    instance_type = "t2.micro"
    ami = "ami-00045d6bafc77e3dc"
    subnet_id = "subnet-05c89a7f34226dece"
    instance_count = var.environment == "production" ? 2 : 1

    tags = {
        Terraform = "true"
        Environment = var.environment
    }
  
}