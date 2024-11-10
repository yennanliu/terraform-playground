# flask_setup.sh
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