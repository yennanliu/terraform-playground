#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras enable python3.8
sudo yum install -y python3.8
sudo pip3 install flask

# Create a simple Flask app
cat <<EOF > /home/ec2-user/app.py
from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "Hello from Flask instance!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF

# Run the Flask app
nohup python3 /home/ec2-user/app.py > /home/ec2-user/app.log 2>&1 &