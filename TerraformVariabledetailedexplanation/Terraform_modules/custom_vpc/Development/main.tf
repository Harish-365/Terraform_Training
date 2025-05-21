module "development-vpc" {
    source = "../../custom_vpc"
    vpcname = "dev-01"
    cidr = "10.0.1.0/24"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_ipv6 = "true"
    vpcenvironment = "dev"
    AWS_REGION = "us-east-2"
     
}
