# app.py
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify(message="Hello, HTTPS world!")

if __name__ == '__main__':
    app.run(ssl_context=('cert.pem', 'key.pem'))  # Configure for HTTPS