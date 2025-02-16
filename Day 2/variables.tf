variable "aws_region" {
  description = "AWS region to deploy resources"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}

variable "environment" {
  description = "Environment for the deployment (e.g., dev, staging, prod)"
}

variable "db_name" {
  description = "Database name for RDS"
}

variable "db_username" {
  description = "Master username for the RDS instance"
}

variable "db_password" {
  description = "Master password for the RDS instance"
  sensitive   = true
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for storing Terraform state"
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for state locking"
}
