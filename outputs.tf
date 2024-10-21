output "wordpress_alb_url" {
  description = "URL of the WordPress Application Load Balancer"
  value       = aws_lb.wordpress_alb.dns_name
}

output "wordpress_db_endpoint" {
  description = "WordPress RDS Endpoint"
  value       = aws_db_instance.wordpress_rds.endpoint
}
