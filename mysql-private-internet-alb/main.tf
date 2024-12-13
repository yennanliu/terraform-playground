provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
  }
}

# Public Subnet for ALB
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}

# Private Subnet for MySQL
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "PrivateSubnet"
  }
}

# Internet Gateway for Public Subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "InternetGateway"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Associate Public Subnet with Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group for MySQL
resource "aws_security_group" "mysql_sg" {
  name        = "MySQLSecurityGroup"
  vpc_id      = aws_vpc.main.id
  description = "Allow traffic to MySQL from ALB"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Only ALB can access MySQL
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "ALBSecurityGroup"
  vpc_id      = aws_vpc.main.id
  description = "Allow external traffic to ALB"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from the internet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# MySQL Instance in Private Subnet
resource "aws_instance" "mysql_instance" {
  ami           = "ami-08d4ac5b634553e16" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id
  security_groups = [aws_security_group.mysql_sg.id]

  tags = {
    Name = "MySQLInstance"
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -y mysql-server
                sudo systemctl start mysqld
                sudo systemctl enable mysqld
                # Set up MySQL root user with default password (optional)
                EOF
}

# Load Balancer
resource "aws_lb" "mysql_lb" {
  name               = "mysql-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public.id]

  tags = {
    Name = "MySQLLoadBalancer"
  }
}

# Target Group for MySQL
resource "aws_lb_target_group" "mysql_tg" {
  name        = "mysql-target-group"
  port        = 3306
  protocol    = "TCP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"
}

# Attach MySQL Instance to Target Group
resource "aws_lb_target_group_attachment" "mysql_attachment" {
  target_group_arn = aws_lb_target_group.mysql_tg.arn
  target_id        = aws_instance.mysql_instance.id
  port             = 3306
}

# Listener for ALB
resource "aws_lb_listener" "mysql_listener" {
  load_balancer_arn = aws_lb.mysql_lb.arn
  port              = 3306
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mysql_tg.arn
  }
}