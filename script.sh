#!/bin/bash
set -e

# actualizar e instalar docker + git
apt update -y
apt install -y docker.io git
systemctl enable docker
systemctl start docker

# directorio de trabajo
cd /home/ubuntu

# clonar o actualizar el repo (REEMPLAZA con tu repo real)
if [ ! -d "ProyectoPython" ]; then
  git clone https://github.com/MiguelC17/ProyectoPython.git ProyectoPython
else
  cd ProyectoPython
  git pull || true
  cd ..
fi

cd ProyectoPython

# construir la imagen Docker y correrla (mapear puerto 80 host -> 8501 contenedor)
docker build -t proyectopython .
# eliminar contenedor anterior si existe
docker rm -f proyectopython || true
docker run -d --name proyectopython -p 80:8501 proyectopython

# fin
