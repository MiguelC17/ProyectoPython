#!/bin/bash
set -e

# actualizar sistema e instalar dependencias
apt update -y
apt install -y docker-compose git

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
docker-compose down || true     # detener si ya hay contenedores corriendo
docker-compose up -d            # construir imagen y ejecutar contenedor
