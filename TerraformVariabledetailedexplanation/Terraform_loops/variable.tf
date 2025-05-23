variable "user_names" {
    type = list(string)
    default = ["user1", "user2", "user3"]
}
 
variable "instance_name" {
    type = list(string)
    default = [ "machine1", "machine2", "machine3" ]

}

variable "instance_forname" {
    type = set(string)
    default = [ "machine1", "machine2", "machine3" ]

}