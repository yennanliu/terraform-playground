# app.py
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify(message="Hello, HTTPS world!")

if __name__ == '__main__':
    #app.run(ssl_context='adhoc') # can use ad-hoc ssl
    #app.run(ssl_context=('cert.pem', 'key.pem'))  # Configure for HTTPS
    #app.run(ssl_context=(app.config['SSL_CERT_FILE'], app.config['SSL_KEY_FILE']))
    context = ('cert.pem', 'key.pem')
    app.run(ssl_context=context)