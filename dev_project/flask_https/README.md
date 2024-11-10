# Flask Https


## Run

```bash

# create key
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes

# run app
python app.py
```