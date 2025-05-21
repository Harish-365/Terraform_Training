## provider
provider "aws" {
    region = var.region
  
}
## Module
module "myvpc" {
    source = "./module/network"  
}



resource "aws_key_pair" "levelup-key" {
    key_name = "levelup-key"
    public_key = file(var.public_key_path)
}

##EC2 instance

resource "aws_instance" "my-instance" {
    ami = var.instance_ami
    instance_type = var.instance_type
    subnet_id = module.myvpc.public_subnet_id
    vpc_security_group_ids = module.myvpc.sg_22_id
    key_name = aws_key_pair.levelup-key.key_name

    tags ={
        Environment = var.environment_tag
    }
  
}