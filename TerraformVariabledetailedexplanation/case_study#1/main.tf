module "levelup-vpc" {
    source = "./webserver"

    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION = var.AWS_REGION
  
}

##Define provider

provider "aws" {
    region = var.AWS_REGION
  
}