#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras enable nginx1
sudo yum install -y nginx

# Configure NGINX to load balance
cat <<EOF > /etc/nginx/conf.d/flask.conf
upstream flask_app {
    server ${aws_instance.flask_instance[0].private_ip}:5000;
    server ${aws_instance.flask_instance[1].private_ip}:5000;
}

server {
    listen 80;

    location / {
        proxy_pass http://flask_app;
    }
}
EOF

sudo systemctl start nginx
sudo systemctl enable nginx