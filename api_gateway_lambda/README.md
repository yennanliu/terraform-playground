# API Gateway + Lambda

## Run
```bash

zip lambda.zip lambda_function.py

terraform init

terraform apply

# test
curl https://<API_GATEWAY_URL>
```