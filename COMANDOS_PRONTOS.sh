#!/bin/bash
################################################################################
# TRADING AGENT B3 - COMANDOS PRONTOS PARA COPIAR-COLAR
# Use os blocos abaixo conforme sua necessidade
################################################################################

echo "===== COMANDOS PRONTOS PARA TRADING AGENT B3 ====="
echo ""
echo "Escolha a opção desejada:"
echo ""
echo "1. INICIAL - Setup completo"
echo "2. DOWNLOAD - Baixar modelos Ollama"
echo "3. DESENVOLVIMENTO - Rodar em dev"
echo "4. PRODUÇÃO - Docker + SystemD"
echo "5. MONITORAMENTO - Ver logs e métricas"
echo "6. LIMPEZA - Limpar cache e old logs"
echo "7. BACKUP - Fazer backup agora"
echo ""
echo "Ou copie os blocos manualmente abaixo:"
echo ""

################################################################################
# 1. SETUP INICIAL
################################################################################

echo "=== 1. SETUP INICIAL ==="
echo "Copie e execute este bloco para setup completo:"
echo ""
cat << 'SETUP'
#!/bin/bash
# Setup completo em ~20 minutos

cd /opt
sudo git clone https://github.com/luanscps/trading-system-agent-b3.git
cd trading-system-agent-b3

python3.11 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

cp .env.example .env
echo "Edite .env:"
nano .env

echo "Todos prontos! Prossiga para download de modelos"
SETUP
echo ""

################################################################################
# 2. DOWNLOAD DE MODELOS
################################################################################

echo "=== 2. DOWNLOAD DE MODELOS ==="
echo "Copie e execute para baixar 5 modelos (17.5GB):"
echo ""
cat << 'MODELS'
#!/bin/bash
# Download de todos os modelos Ollama

echo "⏳ Baixando 5 modelos... (20-30 min)"
echo "📄 Espaço necessário: 17.5GB"

echo "📖 1/5 SmolLM2 1.7B (1.5GB)..."
ollama pull smollm2:1.7b-instruct-q4_K_M

echo "📖 2/5 Mistral 7B (4GB)..."
ollama pull mistral:7b-instruct-q4_K_M

echo "📖 3/5 DeepSeek-R1 8B (4.5GB)..."
ollama pull deepseek-r1:8b

echo "📖 4/5 Qwen2.5-Coder 7B (5GB)..."
ollama pull qwen2.5-coder:7b-instruct-q4_K_M

echo "📖 5/5 Gemma3 4B (2.5GB)..."
ollama pull gemma3:4b-it

echo "✅ Todos os modelos baixados!"
ollama list
MODELS
echo ""

################################################################################
# 3. DESENVOLVIMENTO
################################################################################

echo "=== 3. DESENVOLVIMENTO ==="
echo "Copie e execute para rodar em modo dev:"
echo ""
cat << 'DEV'
#!/bin/bash
# Rodar agent em modo desenvolvimento (com logs no console)

cd /opt/trading-system-agent-b3
source venv/bin/activate

# Modo simulado (sem real trading)
export SIMULATION_MODE=true
export LOG_LEVEL=DEBUG

python -m src.main
DEV
echo ""

################################################################################
# 4. LOGS REAL-TIME
################################################################################

echo "=== 4. MONITORAMENTO - LOGS ==="
echo "Copie para monitorar logs em tempo real:"
echo ""
cat << 'LOGS'
#!/bin/bash
# Ver logs em tempo real

cd /opt/trading-system-agent-b3

echo "📈 Logs em tempo real (Ctrl+C para parar):"
tail -f logs/trading-agent.log

echo ""
echo "Outros comandos de log:"
echo "❌ Erros recentes:"
grep ERROR logs/trading-agent.log | tail -20

echo "💰 Últimos 5 trades:"
cat logs/trades.jsonl | tail -5 | jq

echo "📈 Total de trades hoje:"
cat logs/trades.jsonl | jq 'select(.date | startswith("2026-02-02")) | .action' | sort | uniq -c

echo "🚀 Stats de trades:"
cat logs/trades.jsonl | jq '[.profit] | add / length'
LOGS
echo ""

################################################################################
# 5. DOCKER
################################################################################

echo "=== 5. PRODUÇÃO - DOCKER ==="
echo "Copie para rodar em Docker:"
echo ""
cat << 'DOCKER'
#!/bin/bash
# Build e rodar em Docker

cd /opt/trading-system-agent-b3

# Build
echo "🐧 Building Docker image..."
docker build -t trading-agent-b3:latest .

# Run
echo "🚀 Iniciando container..."
docker run -d \
  --name trading-agent \
  -v $(pwd)/logs:/app/logs \
  -v $(pwd)/data:/app/data \
  --network host \
  --env-file .env \
  --restart unless-stopped \
  trading-agent-b3:latest

echo "✅ Container iniciado!"
echo ""
echo "Monitorar:"
echo "  docker logs -f trading-agent"
echo ""
echo "Parar:"
echo "  docker stop trading-agent"
echo ""
echo "Remover:"
echo "  docker rm trading-agent"
DOCKER
echo ""

################################################################################
# 6. SYSTEMD
################################################################################

echo "=== 6. PRODUÇÃO - SYSTEMD ==="
echo "Copie para rodar 24/7 com SystemD:"
echo ""
cat << 'SYSTEMD'
#!/bin/bash
# Setup SystemD para rodar agent 24/7

# 1. Criar service file
sudo tee /etc/systemd/system/trading-agent.service > /dev/null << 'EOF'
[Unit]
Description=Trading Agent B3 - LLM Analysis 24/7
After=network.target
Wants=ollama.service

[Service]
Type=simple
User=$USER
WorkingDirectory=/opt/trading-system-agent-b3
Environment="PATH=/opt/trading-system-agent-b3/venv/bin"
Environment="PYTHONUNBUFFERED=1"
ExecStart=/opt/trading-system-agent-b3/venv/bin/python -m src.main
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# 2. Recarregar daemon
sudo systemctl daemon-reload

# 3. Habilitar no boot
sudo systemctl enable trading-agent

# 4. Iniciar
sudo systemctl start trading-agent

# 5. Verificar status
sudo systemctl status trading-agent

echo "✅ ServiceD configurado!"
echo ""
echo "Comandos úteis:"
echo "  sudo systemctl status trading-agent"
echo "  sudo systemctl start trading-agent"
echo "  sudo systemctl stop trading-agent"
echo "  sudo systemctl restart trading-agent"
echo "  sudo journalctl -u trading-agent -f"
SYSTEMD
echo ""

################################################################################
# 7. LIMPEZA
################################################################################

echo "=== 7. LIMPEZA ==="
echo "Copie para limpar cache e arquivos antigos:"
echo ""
cat << 'CLEAN'
#!/bin/bash
# Limpeza de cache e logs antigos

cd /opt/trading-system-agent-b3

echo "🗑 Limpando..."

# Limpar Python cache
find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
find . -type f -name "*.pyc" -delete

# Limpar logs antigos (>30 dias)
find logs -name "*.log" -mtime +30 -delete
find logs -name "*.jsonl" -mtime +30 -delete

# Limpar venv cache
rm -rf venv/.cache

echo "✅ Limpeza concluída!"
echo ""
echo "Espaço em disco agora:"
du -sh .
CLEAN
echo ""

################################################################################
# 8. BACKUP
################################################################################

echo "=== 8. BACKUP ==="
echo "Copie para fazer backup agora:"
echo ""
cat << 'BACKUP'
#!/bin/bash
# Fazer backup de logs e dados

cd /opt/trading-system-agent-b3

BACKUP_DIR="/mnt/backups/trading-agent"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "💾 Fazendo backup..."

mkdir -p $BACKUP_DIR

tar -czf $BACKUP_DIR/trading-agent-$TIMESTAMP.tar.gz \
  logs/ \
  data/ \
  .env

echo "✅ Backup criado: $BACKUP_DIR/trading-agent-$TIMESTAMP.tar.gz"
echo ""
echo "Tamanho:"
ls -lh $BACKUP_DIR/trading-agent-$TIMESTAMP.tar.gz
echo ""
echo "Limpar backups > 30 dias:"
find $BACKUP_DIR -name "*.tar.gz" -mtime +30 -delete
echo "✅ Feito!"
BACKUP
echo ""

################################################################################
# 9. REBUILD
################################################################################

echo "=== 9. REBUILD (Reset Completo) ==="
echo "Use APENAS se precisar resetar tudo:"
echo ""
cat << 'REBUILD'
#!/bin/bash
# CUIDADO: Apaga tudo e refaz do zero

echo "⚠️  Isso vai apagar logs, cache e venv"
echo "Tiene certeza? (s/n)"
read -r response

if [ "$response" = "s" ]; then
    cd /opt/trading-system-agent-b3
    
    # Parar se rodando
    sudo systemctl stop trading-agent 2>/dev/null || true
    docker stop trading-agent 2>/dev/null || true
    
    # Limpar
    rm -rf venv
    rm -rf logs/__pycache__
    find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
    
    # Recrear
    python3.11 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    
    echo "✅ Pronto para recomeçar!"
else
    echo "Cancelado"
fi
REBUILD
echo ""

################################################################################
echo "✅ Copie os blocos acima conforme necessário!"
echo ""
