FROM python:3.11-slim

LABEL maintainer="luanscps@gmail.com"
LABEL description="Trading Agent B3 - Sistema autônomo de análise financeira com Ollama LLM"

WORKDIR /app

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copiar requirements
COPY requirements.txt .

# Instalar dependências Python
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código
COPY src/ /app/src/
COPY config/ /app/config/
COPY .env /app/.env

# Criar diretório de logs
RUN mkdir -p /app/logs /app/data

# Volumes para persistência
VOLUME ["/app/logs", "/app/data"]

# Expor porta para Prometheus (opcional)
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8000/health', timeout=5)" || exit 1

# Entry point
CMD ["python", "-m", "src.main"]
