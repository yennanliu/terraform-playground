output "alb_dns_name" {
  description = "DNS Name of the ALB"
  value       = aws_lb.app_lb.dns_name
}

output "flask_instance_ip" {
  description = "Public IP of the Flask instance"
  value       = aws_instance.flask_instance.public_ip
}