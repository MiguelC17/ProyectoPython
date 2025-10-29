provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ProyectoPython"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "allow_streamlit" {
  name        = "allow_streamlit"
  description = "Allow SSH and Streamlit traffic"

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

resource "aws_instance" "streamlit_app" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 en us-east-1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh_key.key_name
  security_groups = [aws_security_group.allow_streamlit.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y git docker
              systemctl start docker
              systemctl enable docker

              cd /home/ec2-user
              git clone https://github.com/MiguelC17/ProyectoPython.git
              cd ProyectoPython
              docker build -t proyectopython .
              docker run -d -p 8501:8501 proyectopython
              EOF

  tags = {
    Name = "StreamlitApp"
  }
}

output "public_ip" {
  value = aws_instance.streamlit_app.public_ip
}
