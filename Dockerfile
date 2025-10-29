# Imagen base de Python
FROM python:3.11-slim

# Crea un directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia el contenido del proyecto dentro del contenedor
COPY . .

# Instala dependencias (primero streamlit por si el requirements.txt falla)
RUN pip install --no-cache-dir streamlit && \
    pip install --no-cache-dir -r requirements.txt || true

# Expón el puerto 8501
EXPOSE 8501

# Comando para iniciar Streamlit apuntando al archivo correcto
CMD ["streamlit", "run", "frontend/src/pages/Home.py", "--server.address=0.0.0.0", "--server.port=8501"]
