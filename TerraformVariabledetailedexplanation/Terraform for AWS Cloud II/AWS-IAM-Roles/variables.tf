variable "AWS_REGION" {
    default = "us-east-1"
  
}

variable "AWS_PUBLICKEY" {
    default = "levelup_key.pub"
  
}

variable "AMIS" {
    default = {us-east-1 = "ami-00045d6bafc77e3dc"
               us-east-2 = "ami-05803413c51f242b7"
              
    }
  
}
