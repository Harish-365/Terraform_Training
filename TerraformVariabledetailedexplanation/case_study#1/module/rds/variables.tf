variable "AWS_REGION" {
    default = "us-east-1"
  
}

variable "ENVIRONMENT" {
    default = "development"
  
}

variable "RDS_CIDR" {
    type = string
    default = "0.0.0.0/0"
}

variable "LEVELUP_RDS_ALLOCATED_STORAGE" {
    type = string
    default = "20"
  
}

variable "LEVELUP_RDS_ENGINE" {
    type = string
    default = "mysql"
}

variable "LEVELUP_RDS_ENGINE_VERSION" {
    type = string
    default = "5.7.44"
}

variable "DB_INSTANCE_CLASS" {
    type = string
    default = "db.t2.micro"
  
}

variable "BACKUP_RETENTION_PERIOD" {
    type = string
    default = "7"
  
}
variable "PUBLICLY_ACCESSIBLE" {
    default = true
  
}

variable "LEVELUP_RDS_USERNAME"{
    type = string
    default = "testdb"
  
}

variable "LEVELUP_RDS_PASSWORD"{
    type = string
    default = "testdb12345"
  
}