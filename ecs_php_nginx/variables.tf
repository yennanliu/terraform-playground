variable "cluster_name" {
	default = "yen-test"
}

variable "region" {
	default = "eu-west-1"
}

variable "logs_group" {
	default = "/ecs/yen-test"
}

variable "nginx_ecr_repository_url" {
	default = "<account number>.dkr.ecr.eu-west-1.amazonaws.com/yen-nginx:latest"
}

variable "php_ecr_repository_url" {
	default = "<account number>.dkr.ecr.eu-west-1.amazonaws.com/yen-php:latest"
}

