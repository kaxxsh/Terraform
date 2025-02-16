variable "name" {
  description = "Prefix for all resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to launch the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}

variable "key_name" {
  description = "Key pair name for EC2 instance"
  type        = string
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key for provisioner connection"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to the EC2 instance"
  type        = map(string)
}
variable "environment" {
  description = "Environment for the instance (e.g., dev, staging, prod)"
  type        = string
}

variable "project" {
  description = "Project name for tagging resources"
  type        = string
}