variable "AWS_REGION" {
    default = "us-east-1"

}

variable "ENVIRONMENT" {
    default = "development"
  
}

variable "AMIS" {
    type = map
    default = {us-east-1 = "ami-0f40c8f97004632f9"
               us-east-2 = "ami-05803413c51f242b7"
    }
}
