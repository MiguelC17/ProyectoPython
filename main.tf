provider "aws" {
  region     = "us-east-1"
  access_key = "TASIAZYJNWORHEOBJTB3B"
  secret_key = "xOQUPKgxbffFqtTqs66kg4QMP6v62K6fFaUYkIrb"
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Permitir tráfico HTTP y SSH"

  ingress {
    description = "HTTP desde cualquier parte"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH desde cualquier parte"
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
  ami                    = "ami-04b70fa74e45c3917" # Ubuntu 22.04 LTS (us-east-1)
  instance_type          = "t2.micro"
  key_name               = "ProyectoPython"
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y apache2
    systemctl start apache2
    systemctl enable apache2
    echo "<h1>¡Servidor desplegado correctamente en AWS!</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "ServidorWebPython"
  }
}

output "public_ip" {
  value = aws_instance.web_app.public_ip
  description = "Dirección IPv4 pública del servidor"
}
