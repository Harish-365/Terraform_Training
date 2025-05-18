##RDS resources
resource "aws_db_subnet_group" "mariadb-subnet" {
  name = "mariadb-subnet"
  subnet_ids = [aws_subnet.levelup-private-1.id, aws_subnet.levelup-private-2.id]

}

## RDS parameter
resource "aws_db_parameter_group" "mariadb-parameter" {
  name = "mariadb-parameter"
  family = "mariadb10.11"

  parameter {
    name = "max_allowed_packet"
    value = "16777216"
  }
}

##RDS instance itself

resource "aws_db_instance" "mariadb" {
    allocated_storage = 20  ## 20 GB of storage
    engine = "mariadb"
    engine_version = "10.11.11"
    instance_class = "db.t3.micro"
    identifier = "mariadb"
    username = "root"
    password = "mariadb141"
    db_subnet_group_name = aws_db_subnet_group.mariadb-subnet.name
    parameter_group_name = aws_db_parameter_group.mariadb-parameter.name
    multi_az = "false"
    vpc_security_group_ids = [aws_security_group.security-mariadb.id]
    storage_type = "gp2"
    backup_retention_period = 30
    availability_zone = aws_subnet.levelup-private-1.availability_zone
    skip_final_snapshot = true
    tags = {
      Name = "MariaDB"

    }

}

output "rds" {
  value = aws_db_instance.mariadb.endpoint
  
}

## once this is deployed, download the mysql-client and connect to the db using the host and the username nd password