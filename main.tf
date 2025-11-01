# Bloque que se incluye como buena practica para asegurarnos de que funciona bien el proveedor de AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

#############################################
# 📦 CONFIGURACIÓN PRINCIPAL DE TERRAFORM
#############################################
provider "aws" {
  region = "us-east-1"   # ✅ Cambia la región si usas otra
}

#############################################
# 🔐 CREACIÓN DE UN SECURITY GROUP (HTTP + SSH)
#############################################
resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow HTTP (80) and SSH (22) inbound traffic"

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#############################################
# 🖥️ INSTANCIA EC2 CON DOCKER + DOCKER COMPOSE
#############################################
resource "aws_instance" "web_app" {
  ami           = "ami-0fc5d935ebf8bc3bc"  # ✅ Ubuntu Server 22.04 LTS (us-east-1)
  instance_type = "t2.micro"               # ✅ Gratis en capa free tier
  key_name      = ""                       # ⚠️ Déjalo vacío si no usas par de claves
  security_groups = [aws_security_group.allow_web.name]

  user_data = <<-EOF
              #!/bin/bash
              set -e
              
              # actualizar sistema e instalar dependencias
              apt update -y
              apt install -y docker.io docker-compose git

              systemctl enable docker
              systemctl start docker

              cd /home/ubuntu

              # Clonar tu repositorio (ajusta si es privado)
              if [ ! -d "ProyectoPython" ]; then
                git clone https://github.com/MiguelC17/ProyectoPython.git ProyectoPython
              else
                cd ProyectoPython
                git pull || true
                cd ..
              fi

              cd ProyectoPython

              # Levantar servicios con Docker Compose
              docker-compose down || true
              docker-compose up -d
              EOF

  tags = {
    Name = "ServidorWeb-Python"
  }

  # Permitir ver la IP pública después del apply
  associate_public_ip_address = true
}


#############################################
# 🌍 SALIDA: MOSTRAR IPv4 PÚBLICA
#############################################
output "instance_public_ip" {
  description = "La dirección IPv4 pública del servidor"
  value       = aws_instance.web_app.public_ip
}

