variable "AWS_REGION" {
    default = "us-east-1"
  
}

variable "AMIS" {
    type = map
    default = {us-east-1 = "ami-00076e19db6f2c629"
               us-east-2 = "ami-05692172625678b4e"

}
}