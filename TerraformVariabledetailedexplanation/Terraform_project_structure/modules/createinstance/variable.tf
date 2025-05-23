variable "public_key_path" {
    default = "~/.ssh/levelup_key.pub"
  
}

variable "vpc_id" {
    type = string
    default = ""
  
}

variable "ENVIRONMENT" {
    type = string
    default = ""
  
}

variable "AMIS" {
    type = map 
    default = {
        "us-east-1" = "ami-00045d6bafc77e3dc"
        "us-east-2" = "ami-05803413c51f242b7"
    }  
}

variable "AWS_REGION" {
    default = "us-east-1"
  
}

variable "PUBLIC_SUBNETS" {
    type = list
}

variable "INSTANCE_TYPE" {
    default = "t2.micro"
  
}