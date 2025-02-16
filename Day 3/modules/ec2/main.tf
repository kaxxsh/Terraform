# Security Group for the EC2 instance
resource "aws_security_group" "this" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["49.37.219.42/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name       = "${var.name}-ec2-sg"
      Environment = var.environment
      Project     = var.project
    }
  )
}

# EC2 Instance with Apache setup and mysql-connection.php deployment
resource "aws_instance" "this" {
  count                       = var.instance_count
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.this.id]

  tags = merge(
    var.tags,
    {
      Name        = "${var.name}-instance-${count.index + 1}"
      Environment = var.environment
      Project     = var.project
    }
  )

  # Connection settings for provisioners
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.ssh_private_key_path)
    host        = self.public_ip
  }

  # Provisioner to install Apache and create /var/www/html/mysql-connection.php
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd php php-mysqli -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "echo '${file("${path.module}/mysql-connection.php")}' | sudo tee /var/www/html/mysql-connection.php",
      "sudo chmod 644 /var/www/html/mysql-connection.php"
    ]
  }

  depends_on = [aws_security_group.this]
}