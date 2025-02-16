output "ec2_instance_ids" {
  description = "List of EC2 instance IDs"
  value       = aws_instance.this[*].id
}

output "ec2_public_ips" {
  description = "List of public IPs for the EC2 instances"
  value       = aws_instance.this[*].public_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.this.id
}