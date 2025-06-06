variable "SSH_CIDR_WEB_SERVER" {
    type = string
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

variable "AWS_REGION" {
    type        = string
    default     = "us-east-2"
}

variable "ENVIRONMENT" {
  description = "AWS VPC Environment Name"
  type        = string
  default     = "Development"
}

variable "public_key_path" {
  description = "Public key path"
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