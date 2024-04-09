# ecs_php_nginx

## Setup

```bash

terraform init

# populate var
terraform apply -var-file="dev.tfvars"

export account_id=
export cluster_name=yen-test

# login ECR
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin $account_id.dkr.ecr.eu-west-1.amazonaws.com

# build docker img
docker buildx build --platform linux/amd64 -t $account_id.dkr.ecr.eu-west-1.amazonaws.com/yen-nginx:latest --push ./docker-nginx

docker buildx build --platform linux/amd64 -t $account_id.dkr.ecr.eu-west-1.amazonaws.com/yen-php:latest --push ./docker-php


# force new deploy

aws ecs update-service --cluster $cluster_name --service nginx-service --force-new-deployment

ate-service --cluster $cluster_name --service php-service --force-new-deployment

# deploy

terraform plan

terraform apply
```

## Ref
- https://www.youtube.com/watch?v=OMQENzpHcYA
- https://github.com/WillBrock/terraform-ecs