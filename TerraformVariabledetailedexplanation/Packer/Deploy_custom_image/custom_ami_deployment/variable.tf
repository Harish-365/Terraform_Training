variable "ENVIRONMENT" {
    default = "Production"
  
}

variable "AWS_REGION" {
    default = "us-east-2"
  
}

variable "public_key_path" {
  default = "~/.ssh/levelup_key.pub"
}

variable "instance_type" {
    default = "t2.micro"
  
}
