variable "cidr_vpc" {
    default = "10.1.0.0/16"
  
}

variable "cidr_subnet" {
    default = "10.1.0.0/24"
  
}

variable "availability_zone" {
    default = "us-east-1f"
  
}

variable "environment_tag" {
    default = "production"
}

variable "AWS_PUBLICKEY" {
    default = "~/.ssh/levelup_key.pub"
  
}