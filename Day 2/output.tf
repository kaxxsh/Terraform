output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [for k, v in aws_subnet.subnets : v.id if startswith(k, "public")]
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = aws_lb.app_lb.dns_name
}

output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.rds.endpoint
}