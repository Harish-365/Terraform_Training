resource "aws_instance" "Myforec2" {
    ami = "ami-00045d6bafc77e3dc"
    instance_type = "t2.micro"
    for_each = toset(var.instance_forname)
    
    tags = {
        name = each.value
}
  
}