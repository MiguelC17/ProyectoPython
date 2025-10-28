#!/bin/bash
sudo apt update -y
sudo apt install -y docker.io docker-compose git
sudo systemctl start docker
sudo systemctl enable docker

cd /home/ubuntu

# Clonar tu repositorio (reemplaza con el tuyo)
git clone https://github.com/tu_usuario/tu_repo.git
cd tu_repo

sudo docker-compose up -d
