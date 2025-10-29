FROM python:3.11-slim

WORKDIR /app
COPY . .

RUN pip install --no-cache-dir streamlit && \
    (pip install --no-cache-dir -r requirements.txt || true) && \
    (pip install --no-cache-dir -r frontend/src/requirements.txt || true)

WORKDIR /app/frontend/src

EXPOSE 8501

CMD ["streamlit", "run", "Home_launcher.py", "--server.address=0.0.0.0", "--server.port=8501"]
