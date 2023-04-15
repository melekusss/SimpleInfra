#Creation of the rds instance
resource "aws_db_instance" "main-rds" {
  allocated_storage      = 10
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = var.db-password #these should be stored in ssm parameter store or AWS SM
  password               = var.db-username #these should be stored in ssm parameter store or AWS SM
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.db-subnet.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  skip_final_snapshot    = true

  tags = {
    Name    = "mysql-database"
    Project = "simpleinfra"
  }
}

#Declaring where db instances can spawn (private-subnet)
resource "aws_db_subnet_group" "db-subnet" {
  name       = "db-subnet"
  subnet_ids = aws_subnet.private-subnets.*.id
  tags = {
    Name    = "db-subnet"
    Project = "simpleinfra"
  }
}

#Declaration of security group for db
resource "aws_security_group" "rds-sg" {
  name        = "RDS-SG"
  description = "Security Group for rds"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    description     = "Allow only mysql traffic from webserver SG"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver-sg.id]
  }

  egress {
    description = "Allow ALL ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "SG for DB"
    Project = "simpleinfra"
  }
}

