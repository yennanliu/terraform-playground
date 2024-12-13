provider "aws" {
  region = "us-east-1"  # Adjust the region as needed
}

# Key Pair
resource "aws_key_pair" "key" {
  key_name   = "flask-key"
  public_key = file("~/.ssh/id_rsa.pub") # Ensure your public SSH key path is correct
}

# Security Group for Flask Instances
resource "aws_security_group" "flask_sg" {
  name        = "flask_sg"
  description = "Allow Flask and NGINX traffic"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust if needed
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust if needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for NGINX Load Balancer
resource "aws_security_group" "nginx_sg" {
  name        = "nginx_sg"
  description = "Allow HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Flask EC2 Instances
resource "aws_instance" "flask_instance" {
  count         = 2
  ami           = "ami-08d4ac5b634553e16"  # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key.key_name
  security_groups = [aws_security_group.flask_sg.name]

  user_data = file("flask_setup.sh") # Flask setup script

  tags = {
    Name = "FlaskInstance${count.index + 1}"
  }
}

# NGINX EC2 Instance
resource "aws_instance" "nginx_instance" {
  ami           = "ami-08d4ac5b634553e16"  # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key.key_name
  security_groups = [aws_security_group.nginx_sg.name]

  user_data = file("nginx_setup.sh") # NGINX setup script

  tags = {
    Name = "NGINXInstance"
  }
}