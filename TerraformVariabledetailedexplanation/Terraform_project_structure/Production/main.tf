provider "aws" {
    region = var.AWS_REGION
    }
  

module "prd-vpc" {
    source = "../modules/vpc"
    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION = var.AWS_REGION

}

module "prd-instances" {
    source = "../modules/createinstance"
    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION = var.AWS_REGION
    vpc_id = module.prd-vpc.my_vpc_id
    PUBLIC_SUBNETS = module.prd-vpc.public_subnets
}

