# 🚀 DEPLOY - Trading Agent em Produção

## 3 Opções de Deploy

---

## 1️⃣ Docker Standalone

### Build da Imagem

```bash
# No repositório local
docker build -t trading-agent-b3:latest .
```

### Rodar Container

```bash
docker run -d \
  --name trading-agent \
  -v $(pwd)/logs:/app/logs \
  -v $(pwd)/data:/app/data \
  --network host \
  --env-file .env \
  --restart unless-stopped \
  trading-agent-b3:latest
```

### Monitorar

```bash
# Logs em tempo real
docker logs -f trading-agent

# Ver status
docker ps -a | grep trading-agent

# Parar
docker stop trading-agent

# Reiniciar
docker restart trading-agent

# Remover
docker rm trading-agent
```

---

## 2️⃣ Docker Compose (Recomendado)

### Criar docker-compose.yml

```yaml
version: '3.8'

services:
  trading-agent:
    build: .
    container_name: trading-agent
    hostname: trading-agent-b3
    networks:
      - trading
    volumes:
      - ./logs:/app/logs
      - ./data:/app/data
    environment:
      OLLAMA_HOST: http://ollama:11434
    env_file:
      - .env
    restart: unless-stopped
    depends_on:
      - ollama

  ollama:
    image: ollama/ollama:latest
    container_name: ollama-mistral
    ports:
      - "11434:11434"
    volumes:
      - ollama-data:/root/.ollama
    networks:
      - trading
    environment:
      OLLAMA_HOST: 0.0.0.0:11434

volumes:
  ollama-data:

networks:
  trading:
    driver: bridge
```

### Executar

```bash
# Subir serviços
docker-compose up -d

# Ver logs
docker-compose logs -f trading-agent

# Parar tudo
docker-compose down

# Limpar volumes
docker-compose down -v
```

---

## 3️⃣ SystemD (Linux - Sempre Rodando)

### 1. Criar Service File

```bash
sudo tee /etc/systemd/system/trading-agent.service > /dev/null << 'EOF'
[Unit]
Description=Trading Agent B3 - LLM Analysis 24/7
After=network.target
Wants=ollama.service

[Service]
Type=simple
User=seu_usuario
WorkingDirectory=/DATA/AppData/trading-agent
Environment="PATH=/DATA/AppData/trading-agent/venv/bin"
Environment="PYTHONUNBUFFERED=1"
ExecStart=/DATA/AppData/trading-agent/venv/bin/python -m src.main
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
```

### 2. Recarregar Daemon

```bash
sudo systemctl daemon-reload
```

### 3. Ativar no Boot

```bash
sudo systemctl enable trading-agent
```

### 4. Iniciar Service

```bash
sudo systemctl start trading-agent
```

### 5. Monitorar

```bash
# Ver status
sudo systemctl status trading-agent

# Logs em tempo real
sudo journalctl -u trading-agent -f

# Últimas 100 linhas
sudo journalctl -u trading-agent -n 100

# Filtrar por erro
sudo journalctl -u trading-agent -p err
```

### 6. Controlar Service

```bash
# Parar
sudo systemctl stop trading-agent

# Reiniciar
sudo systemctl restart trading-agent

# Desativar do boot
sudo systemctl disable trading-agent

# Desativar completamente
sudo systemctl mask trading-agent
```

---

## 📂 Configuração de Produção

### .env

```bash
# Desabilitar modo simulado
SIMULATION_MODE=false
ENABLE_REAL_TRADING=true

# Aumentar confiança mínima em produção
MIN_CONFIDENCE=0.85

# Database persistente
DATABASE_URL=postgresql://user:pass@db:5432/trading_db
REDIS_URL=redis://redis:6379/0

# Alertas
SLACK_WEBHOOK=https://hooks.slack.com/services/...
TELEGRAM_TOKEN=...
```

---

## 📈 Monitoramento em Produção

### Prometheus

```yaml
# prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'trading-agent'
    static_configs:
      - targets: ['localhost:8000']
```

### Grafana Dashboard

1. Adicionar datasource Prometheus
2. Importar dashboard
3. Visualizar métricas em tempo real

---

## 🔐 Segurança em Produção

- [ ] Não commitar .env (já está em .gitignore)
- [ ] Usar variáveis de ambiente para credenciais
- [ ] Ativar HTTPS se expor API
- [ ] Usar secrets do Docker/Kubernetes
- [ ] Limitar acesso a porta 11434 (Ollama)
- [ ] Backup regular de `logs/` e `data/`
- [ ] Monitorar uso de CPU/RAM
- [ ] Alertas para falhas

---

## 📈 Backup e Recuperação

### Backup Automático

```bash
#!/bin/bash
# cron: 0 2 * * * /path/to/backup.sh

BACKUP_DIR="/backups/trading-agent"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

tar -czf $BACKUP_DIR/trading-agent-$TIMESTAMP.tar.gz \
  /DATA/AppData/trading-agent/logs/ \
  /DATA/AppData/trading-agent/data/

# Manter apenas últimos 30 dias
find $BACKUP_DIR -name "*.tar.gz" -mtime +30 -delete
```

### Recuperar de Backup

```bash
tar -xzf /backups/trading-agent/trading-agent-20260201_120000.tar.gz \
  -C /DATA/AppData/trading-agent/
```

---

## 🔧 Troubleshooting de Deploy

### Agent não inicia

```bash
# Verificar logs
sudo journalctl -u trading-agent -n 50

# Verificar conectividade Ollama
curl http://10.41.10.151:11434/api/tags

# Verificar arquivo .env
cat .env | grep OLLAMA
```

### Alto uso de memória

```bash
# Monitorar RAM
watch -n 1 'docker stats'

# Reduzir modelo em .env
OLLAMA_MODEL_STANDARD=smollm2:1.7b-instruct-q4_K_M
```

### Logs cheios

```bash
# Limpar logs antigos
find ./logs -name "*.log" -mtime +30 -delete

# Ou usar logrotate
sudo tee /etc/logrotate.d/trading-agent > /dev/null << 'EOF'
/DATA/AppData/trading-agent/logs/*.log {
    daily
    rotate 30
    compress
    delaycompress
    notifempty
    create 0640 seu_usuario seu_usuario
}
EOF
```

---

## 📌 Checklist de Deploy

- [ ] .env configurado e testado
- [ ] Modelos Ollama baixados
- [ ] Pastas de logs e data criadas
- [ ] Backups configurados
- [ ] Monitoramento ativo (Prometheus/Grafana)
- [ ] Alertas configurados
- [ ] Documentado em wiki interna
- [ ] Teste de falha/recovery
- [ ] Teste de rollback
- [ ] Go-live checklist concluído

---

**Suporte**: Abrir issue no GitHub ou contatar luanscps@gmail.com
