# Dockerfile para Meta-Router

FROM python:3.12-slim

WORKDIR /app

# Instalar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código
COPY src/router/ src/router/

# Variables de entorno por defecto
ENV PYTHONPATH=/app

# Exponer puerto
EXPOSE 8000

# Ejecutar servicio
CMD ["python", "-m", "src.router.api_service"]
