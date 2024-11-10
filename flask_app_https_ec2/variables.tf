# variables.tf
variable "aws_region" {
  description = "AWS region to deploy to"
  default     = "us-west-2"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "path_to_key" {
  description = "Path to your SSH private key"
  type        = string
}