#!/bin/bash
sudo apt update -y
sudo apt install -y docker.io docker-compose python3-pip
sudo systemctl enable docker
sudo systemctl start docker

cd /home/ubuntu

# Clonar tu repositorio (reemplaza con el tuyo)
git clone https://github.com/MiguelC17/ProyectoPython.git ProyectoPython
cd ProyectoPython

sudo docker-compose up -d
