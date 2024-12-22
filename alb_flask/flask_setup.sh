#!/bin/bash
# Install and start Flask application
sudo yum update -y
sudo yum install python3 -y
pip3 install flask

# Create Flask app
cat <<EOF > /home/ec2-user/app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return ">>> Hello, World! This is a Flask app behind an ALB!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
EOF

# Start Flask app
nohup python3 /home/ec2-user/app.py &