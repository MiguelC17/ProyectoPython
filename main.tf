provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Permitir trafico HTTP y SSH"

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
}

resource "aws_instance" "web_app" {
  ami           = "ami-0fc5d935ebf8bc3bc" # Amazon Linux 2023 (válida para us-east-1)
  instance_type = "t2.micro"
  key_name      = "ProyectoPython"          # Cambia esto por tu clave real

  security_groups = [aws_security_group.allow_http.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker git
              systemctl start docker
              systemctl enable docker

              cd /home/ec2-user
              git clone https://github.com/tu_usuario/ProyectoPython.git
              cd ProyectoPython

              docker build -t miapp .
              docker run -d -p 80:8501 miapp
              EOF

  tags = {
    Name = "web-app"
  }
}


output "public_ip" {
  value = aws_instance.web_app.public_ip
}
