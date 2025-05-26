variable "ENVIRONMENT" {
    default = "development"
  
}

variable "AWS_REGION" {
    default = "us-east-1"
  
}

variable "SSH_CIRD_WEB_SERVER" {
    default = "0.0.0.0/0"
}

variable "INSTANCE_TYPE" {
    default = "t2.micro"
  
}

variable "AMIS" {
    type = map
    default = {us-east-1 = "ami-0f40c8f97004632f9"
               us-east-2 = "ami-05803413c51f242b7"
    }
}

variable "public_key_path" {
    default = "~/.ssh/levelup_key.pub"
  
}

variable "vpc_private_subnet1" {
  description = "AWS VPC Environment Name"
  type        = string
  default     = ""
}

variable "vpc_private_subnet2" {
  description = "AWS VPC Environment Name"
  type        = string
  default     = ""
}


variable "vpc_id" {
  description = "AWS VPC Environment Name"
  type        = string
  default     = ""
}


variable "vpc_public_subnet1" {
  description = "AWS VPC Environment Name"
  type        = string
  default     = ""
}

variable "vpc_public_subnet2" {
  description = "AWS VPC Environment Name"
  type        = string
  default     = ""
}