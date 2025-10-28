provider "aws" {
  region = "us-east-1" # cámbialo a tu región
}


# Instancia EC2
resource "aws_instance" "web_app" {
  ami           = "ami-0c55b159cbfafe1f0" # Ubuntu 22.04 (puedes verificar en AWS)
  instance_type = "t2.micro"
  key_name      = "ProyectoPython"

  # Seguridad: abre puertos 22 (SSH) y 8501 (Streamlit)
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              # Actualizar sistema
              apt update -y
              apt upgrade -y

              # Instalar Python y dependencias
              apt install -y python3 python3-pip git

              # Clonar tu repositorio (ajusta el enlace)
              cd /home/ubuntu
              git clone https://github.com/MiguelC17/ProyectoPython.git app

              cd app/src

              # Instalar Streamlit
              pip install streamlit

              # Ejecutar Streamlit en segundo plano
              nohup streamlit run pages/Home.py --server.port=8501 --server.address=0.0.0.0 &
              EOF

  tags = {
    Name = "StreamlitApp"
  }
}

# Grupo de seguridad para la instancia
resource "aws_security_group" "web_sg" {
  name_prefix = "streamlit-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8501
    to_port     = 8501
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

# Mostrar IP pública al finalizar
output "public_ip" {
  value = aws_instance.web_app.public_ip
}

output "access_url" {
  value = "http://${aws_instance.web_app.public_ip}:8501"
}
