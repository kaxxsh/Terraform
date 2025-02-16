# VPC
resource "aws_vpc" "web_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "kamesh-web-vpc"
  }
}

# Subnet
resource "aws_subnet" "web_subnet" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a" 
  map_public_ip_on_launch = true
  tags = {
    Name = "web-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "web_igw" {
  vpc_id = aws_vpc.web_vpc.id
  tags = {
    Name = "web-igw"
  }
}

# Route Table
resource "aws_route_table" "web_route_table" {
  vpc_id = aws_vpc.web_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web_igw.id
  }
  tags = {
    Name = "web-route-table"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "web_route_table_assoc" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.web_route_table.id
}

# Security Group
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.web_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

# EC2 Instance
resource "aws_instance" "web_instance" {
  ami           = "ami-0005ee01bca55ab66" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.web_subnet.id
  security_groups = [
    aws_security_group.web_sg.id
  ]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Welcome to my web server on AWS!</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "web-server"
  }
}

# Output the public IP of the instance
output "web_server_public_ip" {
  value = aws_instance.web_instance.public_ip
  description = "The public IP address of the web server"
}