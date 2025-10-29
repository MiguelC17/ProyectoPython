terraform {
  required_providers {
    aws = { source = "hashicorp/aws" }
  }
}

provider "aws" {
  region = "us-east-1" 
}

# Buscar la AMI Ubuntu 22.04 (canónico) más reciente en la región
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# VPC por defecto
data "aws_vpc" "default" {
  default = true
}

# Security group: permitir 80 (HTTP) y 22 (SSH) — opcional 8501 también si prefieres
resource "aws_security_group" "allow_http" {
  name        = "allow_http_streamlit"
  description = "Allow HTTP (80) and SSH (22)"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
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
}

# EC2 instance
resource "aws_instance" "streamlit_app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  # Ejecuta script.sh que debe estar en la misma carpeta que main.tf
  user_data = file("${path.module}/script.sh")

  tags = {
    Name = "StreamlitApp"
  }
}

output "public_ip" {
  description = "IPv4 publica de la instancia"
  value       = aws_instance.streamlit_app.public_ip
}

output "access_url" {
  value = "http://${aws_instance.streamlit_app.public_ip}"
}
