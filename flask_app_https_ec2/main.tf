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

  user_data = <<-EOF
            #!/bin/bash
            # Install dependencies
            yum update -y
            yum install -y python3

            # Install pip and Flask
            python3 -m ensurepip --upgrade
            pip3 install flask

            # Set up app directory
            mkdir -p /home/ec2-user/flask_app
            cd /home/ec2-user/flask_app

            # Flask app script
            cat << 'APP' > app.py
            from flask import Flask, jsonify

            app = Flask(__name__)

            @app.route('/')
            def home():
                return jsonify(message="Hello, HTTPS world!")

            if __name__ == '__main__':
                app.run(host='0.0.0.0', ssl_context=('cert.pem', 'key.pem'))
            APP

            # Generate self-signed SSL certificate
            openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes -subj "/CN=localhost"

            # Start the app
            python3 app.py &
        EOF

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