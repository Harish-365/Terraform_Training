module "level_vpc" {
    source  = "terraform-aws-modules/vpc/aws"

    name = "vpc-${var.ENVIRONMENT}"
    cidr = "10.0.0.0/16"

    azs = ["${var.AWS_REGION}a", "${var.AWS_REGION}b"]
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
    enable_nat_gateway = false
    enable_vpn_gateway = false
    map_public_ip_on_launch = "true"

    tags = {
        Environment = var.ENVIRONMENT
        Terraform = "true"
    }
}

##output specific to custom VPC

output "my_vpc_id" {
    value = module.level_vpc.vpc_id
  
}

output "private_subnets" {
    value = module.level_vpc.private_subnets
  
}

output "public_subnets" {
    value = module.level_vpc.public_subnets
  
}