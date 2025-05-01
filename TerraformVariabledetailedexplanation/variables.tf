variable "AWS_REGION" {
    default = "us-east-1"
  
}

variable "Security_Groups" {
    type = list
    default = ["sg-123", "sg-1234"]
}