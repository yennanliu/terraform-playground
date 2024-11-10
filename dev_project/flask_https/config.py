# config.py
class Config:
    SSL_CERT_FILE = 'cert.pem'
    SSL_KEY_FILE = 'key.pem'
    DEBUG = True  # Only enable for development

# Load this config in your app
app.config.from_object('config.Config')