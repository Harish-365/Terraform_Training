data "aws_ip_ranges" "us_east_ip_range" {
    regions = ["us-east-1", "us-east-2"]
    services = ["ec2"]
}

resource "aws_security_group" "sg_custom_security" {
    name = sg_custom_security
    ingress {
        from_port = "443"
        to_port = "443"
        protocol = "tcp"
        cidr_blocks = slice(data.aws_ip_ranges.us_east_ip_range.cidr_blocks, 0, 50)
    }

tags = {
    Create_date = data.aws_ip_ranges.us_east_ip_range.create_date
    SyncToken = data.aws_ip_ranges.us_east_ip_range.sync_token
}
  
}