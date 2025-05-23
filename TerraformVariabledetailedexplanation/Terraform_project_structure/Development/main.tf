provider "aws" {
    region = var.AWS_REGION
    }
  

module "dev-vpc" {
    source = "../modules/vpc"
    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION = var.AWS_REGION

}

module "dev-instances" {
    source = "../modules/createinstance"
    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION = var.AWS_REGION
    vpc_id = module.dev-vpc.my_vpc_id
    PUBLIC_SUBNETS = module.dev-vpc.public_subnets
}

