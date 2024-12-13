output "flask_instance_ips" {
  description = "Public IP addresses of Flask instances"
  value       = aws_instance.flask_instance[*].public_ip
}

output "nginx_instance_ip" {
  description = "Public IP address of NGINX instance"
  value       = aws_instance.nginx_instance.public_ip
}