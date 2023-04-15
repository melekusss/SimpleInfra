#Create simple EC2 instance
resource "aws_instance" "webserver" {
  ami                         = "ami-0fa03365cde71e0ab" // Amazon Linux2
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.webserver-sg.id]
  subnet_id                   = aws_subnet.public-subnets[0].id
  associate_public_ip_address = true
  #Launch script to start apache webserver
  user_data = file("user_data.sh")

  tags = {
    Name    = "Webserver"
    Project = "simpleinfra"
  }
}

#Create SG for WebServer
resource "aws_security_group" "webserver-sg" {
  name        = "WebServer-SG"
  description = "Security Group for my WebServer"
  vpc_id      = aws_vpc.main-vpc.id

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      description = "Allow HTTP/HTTPS from internet"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Allow ALL ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "SG for webserver"
    Project = "simpleinfra"
  }
}
