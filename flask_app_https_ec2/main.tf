# main.tf
provider "aws" {
  region = "us-west-2"  # Change to your preferred region
}

resource "aws_instance" "flask_app" {
  ami           = "ami-08d4ac5b634553e16"  # Amazon Linux 2 AMI
  instance_type = "t2.micro"               # Choose an appropriate instance type
  key_name      = var.key_name

  # Allow SSH and HTTPS (port 443) access
  vpc_security_group_ids = [aws_security_group.flask_app_sg.id]

  user_data = file("flask_setup.sh")

  tags = {
    Name = "FlaskAppInstance"
  }
}

# Define a security group for the instance
resource "aws_security_group" "flask_app_sg" {
  name_prefix = "flask_app_sg_"

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
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

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.flask_app.public_ip
}