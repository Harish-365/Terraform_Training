variable "LEVEL_VPC_CIDR_BLOCK" {
    default = "10.0.0.0/16"
    type = string
}

variable "ENVIRONMENT" {
    default = "Development"
    type = string
  
}

variable "LEVEL_VPC_PRIVATE_SUBNET1_CIDR_BLOCK" {
    default = "10.0.1.0/24"
    type = string
  
}

variable "LEVEL_VPC_PRIVATE_SUBNET2_CIDR_BLOCK" {
    default = "10.0.2.0/24"
    type = string
  
}

variable "LEVEL_VPC_PUBLIC_SUBNET1_CIDR_BLOCK" {
    default = "10.0.101.0/24"
    type = string
  
}

variable "LEVEL_VPC_PUBLIC_SUBNET2_CIDR_BLOCK" {
    default = "10.0.102.0/24"
    type = string
  
}

variable "AWS_REGION" {
    default = "us-east-1"
    type = string
  
}