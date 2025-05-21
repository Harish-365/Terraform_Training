module "developmentqa-vpc" {
    source = "../../custom_vpc"
    vpcname = "dev-qa-01"
    cidr = "10.0.2.0/24"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_ipv6 = "false"
    vpcenvironment = "devqa"
    
}