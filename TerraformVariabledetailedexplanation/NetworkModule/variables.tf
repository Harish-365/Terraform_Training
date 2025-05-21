variable "region" {
    default = "us-east-1"
  
}

variable "public_key_path" {
    default = "~/.ssh/levelup_key.pub"
  
}

variable "environment_tag" {
    default = "production"
}

variable "instance_ami" {
    default = "ami-00045d6bafc77e3dc"
  
}

variable "instance_type" {
    default = "t2.micor"
  
}