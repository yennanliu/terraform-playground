output "mysql_instance_private_ip" {
  description = "Private IP address of the MySQL instance"
  value       = aws_instance.mysql_instance.private_ip
}

output "load_balancer_dns" {
  description = "DNS name of the Load Balancer"
  value       = aws_lb.mysql_lb.dns_name
}