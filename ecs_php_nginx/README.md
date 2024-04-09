# ecs_php_nginx

## Setup

```bash

terraform init

# populate var
terraform apply -var-file="dev.tfvars"

# login ECR
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin $account_id.dkr.ecr.eu-west-1.amazonaws.com

# build docker img
docker buildx build --platform linux/amd64 -t $account_id.dkr.ecr.eu-west-1.amazonaws.com/yen-nginx:latest --push ./docker-nginx


docker buildx build --platform linux/amd64 -t $account_id.dkr.ecr.eu-west-1.amazonaws.com/yen-php:latest --push ./docker-php
```

## Ref
- https://www.youtube.com/watch?v=OMQENzpHcYA
- https://github.com/WillBrock/terraform-ecs