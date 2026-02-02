# 📖 TRADING AGENT B3 - GUIA TÉCNICO COMPLETO

**Documentação técnica aprofundada do sistema de trading com 5 modelos IA em cascata**

---

## 📋 Índice

1. [Visão Geral da Arquitetura](#visão-geral)
2. [Especificações do Hardware](#hardware)
3. [Modelos IA em Detalhe](#modelos)
4. [Instalação Passo a Passo](#instalação)
5. [Configuração Avançada](#configuração)
6. [Monitoramento e Logs](#monitoramento)
7. [Troubleshooting](#troubleshooting)
8. [Performance Tuning](#performance)
9. [Backup e Recovery](#backup)
10. [Roadmap Futuro](#roadmap)

---

## 🏗️ Visão Geral da Arquitetura {#visão-geral}

### Fluxo Completo de Análise

```
┌─────────────────────────────────────────────────┐
│         1️⃣ COLETA DE DADOS (Real-time)          │
├─────────────────────────────────────────────────┤
│ • B3 via brapi.dev (gratuito)                  │
│ • NeoLogica Profit Pro (opcional)              │
│ • NewsFeeds financeiras (Neofeed)              │
│ • OHLCV histórico (1 min, 5 min, 1h, 1d)      │
└────────────────────┬────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────┐
│     2️⃣ PROCESSAMENTO (Python + LangChain)       │
├─────────────────────────────────────────────────┤
│ ┌────────────────────────────────────────────┐ │
│ │ SmolLM2 1.7B (300-500ms)                   │ │
│ │ → Análise rápida de sentimento             │ │
│ │ → Score < 75%? ❌ Descarta                 │ │
│ └────────────────────────────────────────────┘ │
│                     ↓                          │
│ ┌────────────────────────────────────────────┐ │
│ │ Mistral 7B (1-2s)                          │ │
│ │ → Análise técnica detalhada                │ │
│ │ → MACD, RSI, Bollinger Bands              │ │
│ │ → Score < 60%? ❌ Descarta                 │ │
│ └────────────────────────────────────────────┘ │
│                     ↓                          │
│ ┌────────────────────────────────────────────┐ │
│ │ DeepSeek-R1 8B (2-3s)                      │ │
│ │ → Validação matemática                    │ │
│ │ → Cálculo Sharpe Ratio                    │ │
│ │ → Risco > tolerância? ❌ Descarta         │ │
│ └────────────────────────────────────────────┘ │
│                     ↓                          │
│ ┌────────────────────────────────────────────┐ │
│ │ Qwen2.5-Coder 7B (1-2s)                    │ │
│ │ → Processamento de dados                  │ │
│ │ → Validação de entrada                    │ │
│ │ → Dados inválidos? ❌ Descarta             │ │
│ └────────────────────────────────────────────┘ │
│                     ↓                          │
│ ┌────────────────────────────────────────────┐ │
│ │ Gemma3 4B (800ms)                          │ │
│ │ → Análise multimodal de sentimento         │ │
│ │ → Score final                              │ │
│ └────────────────────────────────────────────┘ │
└────────────────────┬────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────┐
│   3️⃣ DECISÃO E EXECUÇÃO (100-500ms)             │
├─────────────────────────────────────────────────┤
│ Score ≥ 0.75?                                  │
│ → BUY Order                                    │
│ → Log em trading-agent.log (JSONL)             │
│ → Métrica em Prometheus                        │
│ → Alert em Telegram (opcional)                 │
└─────────────────────────────────────────────────┘

⏱️  LATÊNCIA TOTAL: ~5-10 segundos
```

---

## 🖥️ Especificações do Hardware {#hardware}

### Seu Servidor - IBM LENOVO X3650 M5

```
┌─────────────────────────────────────────────────────┐
│        HOMELAB - IBM LENOVO X3650 M5               │
├─────────────────────────────────────────────────────┤
│ Modelo: 5462AC1                                    │
│ Socket: 2x LGA 2011-v3                             │
│                                                     │
│ CPU: 24x Intel(R) Xeon(R) E5-2670 v3              │
│   • Cores: 24 (12 cores por socket x 2)           │
│   • Threads: 48 (2x threading)                    │
│   • TDP: 120W por socket (240W total)             │
│   • Frequência base: 2.3 GHz                      │
│   • Turbo: até 3.1 GHz                            │
│   • Cache L3: 30MB por socket                     │
│   • Arquitetura: Haswell-EP                       │
│                                                     │
│ RAM: 64GB DDR4 @ 2133MHz                          │
│   • 4x 16GB Samsung SF4722G4CKHH6DFSDS            │
│   • Tipo: RDIMM (Registered DIMM)                 │
│   • ECC: Sim (critical para servidor)             │
│   • Bandwidth: ~68GB/s                            │
│                                                     │
│ Storage: ServeRAID M1215 RAID 10                  │
│   • Total: 638GB usável                           │
│   • Configuração: 5 drives em RAID10              │
│   • Redundância: 2x proteção                      │
│   • Performance: ~1.5k IOPS (leitura)             │
│                                                     │
│ Virtualização: PROXMOX v8.4                       │
│   • QEMU/KVM hypervisor                           │
│   • Cluster ready (até 3 nós)                     │
│   • HA (High Availability) disponível             │
│                                                     │
│ Rede: MIKROTIK X64 Bridge + VLAN                  │
│   • Intranet via VLAN segmentada                  │
│   • BGP ready                                     │
│   • QoS configurável                              │
│                                                     │
│ POWER: ~500W (modo idle) / 900W (pico)            │
│ COOLING: Hot-swap fans (redundância)              │
│ NOISE: ~35dB (típico em intranet)                 │
└─────────────────────────────────────────────────────┘
```

### Capacidade para Trading Agent

| Recurso | Disponível | Necessário | Margem |
|---------|-----------|------------|--------|
| **CPU** | 24 cores / 48 threads | 4-8 cores | ✅ Excelente |
| **RAM** | 64GB | 32-35GB | ✅ 29GB livre |
| **Storage** | 638GB | 17.5GB modelos + logs | ✅ 99.7% livre |
| **Network** | 1 Gbps (intranet) | ~10 Mbps picos | ✅ Muito sobra |
| **GPU** | Nenhuma | Opcional (CPU OK) | ⚠️ CPU suficiente |

---

## 🧠 Modelos IA em Detalhe {#modelos}

### SmolLM2 1.7B (Camada 1: Filtragem Rápida)

```
Arquitetura: Transformer (1.7B parâmetros)
Treinamento: SmallLanguageModels v2
Optimização: QuantQ4_K_M (quantizado 4-bit)

Usos:
  ✓ Análise rápida de sentimento
  ✓ Classificação binária (bull/bear)
  ✓ Detecção de notícias importantes
  ✓ Pré-filtro (economiza tempo)

Latência: 300-500ms (GPU-CPU hybrid)
Memória: 1.5GB VRAM
Troughput: ~50 análises/minuto
Accurácia: ~82% em datasets de sentimento
```

### Mistral 7B (Camada 2: Análise Técnica)

```
Arquitetura: Transformer otimizado (7B parâmetros)
Treinamento: Mistral AI (dezembro 2023)
Optimização: Grouped-Query Attention (velocidade)

Usos:
  ✓ Análise técnica completa (MACD, RSI, Bollinger)
  ✓ Interpretação de padrões gráficos
  ✓ Validação de sinais
  ✓ Contexto histórico

Latência: 1-2s (contexto 8k tokens)
Memória: 4GB VRAM
Troughput: ~20 análises/minuto
Accurácia: ~78% em previsões técnicas de curto prazo
```

### DeepSeek-R1 8B (Camada 3: Raciocínio Matemático)

```
Arquitetura: Reasoning-focused Transformer (8B)
Treinamento: DeepSeek (2025)
Optimização: Para cálculos complexos

Usos:
  ✓ Cálculo Sharpe Ratio
  ✓ Drawdown máximo
  ✓ Validação risk/reward
  ✓ Decisão final (score)

Latência: 2-3s (reasoning chain-of-thought)
Memória: 4.5GB VRAM
Troughput: ~15 análises/minuto
Accurácia: ~95% em cálculos matemáticos
```

### Qwen2.5-Coder 7B (Camada 4: Processamento de Dados)

```
Arquitetura: Code-optimized Transformer (7B)
Treinamento: Alibaba Qwen (2025)
Optimização: Para processamento estruturado

Usos:
  ✓ Validação de formatos JSON
  ✓ Processamento de dados brutos
  ✓ Transformação de valores
  ✓ Script execution

Latência: 1-2s
Memória: 5GB VRAM
Troughput: ~20 análises/minuto
Accurácia: ~99% em parsing estruturado
```

### Gemma3 4B (Camada 5: Análise Final)

```
Arquitetura: Multimodal Transformer (4B)
Treinamento: Google DeepMind (2025)
Optimização: Para análise de sentimento

Usos:
  ✓ Análise final de sentimento
  ✓ Suporte a imagens (charts)
  ✓ Score consolidado
  ✓ Confiança final

Latência: 800ms
Memória: 2.5GB VRAM
Troughput: ~50 análises/minuto
Accurácia: ~85% em análise multimodal
```

---

## 🔧 Instalação Passo a Passo {#instalação}

### Passo 1: Preparar Ambiente PROXMOX

```bash
# 1.1 SSH no Proxmox
ssh root@seu-proxmox-ip

# 1.2 Criar VM para Trading Agent
pvesh create /nodes/proxmox1/qemu \
  -vmid 100 \
  -name trading-agent-b3 \
  -memory 36000 \
  -cores 8 \
  -sockets 2 \
  -cpu cputype=host \
  -net0 virtio,bridge=vmbr0 \
  -ostype l26 \
  -ide2 local:iso/ubuntu-22.04-server-amd64.iso,media=cdrom

# 1.3 Iniciar VM e instalar Ubuntu 22.04 LTS
```

### Passo 2: Configurar Ubuntu 22.04

```bash
# 2.1 Atualizar sistema
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential git curl wget htop tmux

# 2.2 Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# 2.3 Instalar Python 3.11
sudo apt install -y python3.11 python3.11-venv python3.11-dev

# 2.4 Instalar Ollama (se na VM, ou remoto via 10.41.10.151:11434)
curl https://ollama.ai/install.sh | sh
ollama serve  # Em background
```

### Passo 3: Clonar Repositório

```bash
cd /opt
sudo git clone https://github.com/luanscps/trading-system-agent-b3.git
cd trading-system-agent-b3
sudo chown -R $USER:$USER .
```

### Passo 4: Setup Python

```bash
python3.11 -m venv venv
source venv/bin/activate
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt
```

### Passo 5: Configurar .env

```bash
cp .env.example .env
nano .env

# Adicionar:
BRAPI_TOKEN=seu_token_brapi
OLLAMA_HOST=http://10.41.10.151:11434
OLLAMA_MODEL_FAST=smollm2:1.7b-instruct-q4_K_M
OLLAMA_MODEL_STANDARD=mistral:7b-instruct-q4_K_M
OLLAMA_MODEL_REASONING=deepseek-r1:8b
OLLAMA_MODEL_CODER=qwen2.5-coder:7b-instruct-q4_K_M
OLLAMA_MODEL_SENTIMENT=gemma3:4b-it
LOG_DIR=/opt/trading-agent-b3/logs
DATABASE_PATH=/opt/trading-agent-b3/data
```

### Passo 6: Rodar Agent

```bash
source venv/bin/activate
python -m src.main
```

---

## ⚙️ Configuração Avançada {#configuração}

### Variáveis de Ambiente Completas

```bash
# === B3 API ===
BRAPI_TOKEN=seu_token_brapi          # Gerar em https://brapi.dev
BRAPI_BASE_URL=https://brapi.dev/api
B3_TICKERS=PETR4,VALE3,IBOV          # Ativos a monitorar

# === OLLAMA ===
OLLAMA_HOST=http://10.41.10.151:11434
OLLAMA_MODEL_FAST=smollm2:1.7b-instruct-q4_K_M
OLLAMA_MODEL_STANDARD=mistral:7b-instruct-q4_K_M
OLLAMA_MODEL_REASONING=deepseek-r1:8b
OLLAMA_MODEL_CODER=qwen2.5-coder:7b-instruct-q4_K_M
OLLAMA_MODEL_SENTIMENT=gemma3:4b-it
OLLAMA_TIMEOUT=30                    # Segundos

# === TRADING ===
SIMULATION_MODE=true                # true=simulado, false=real
ENABLE_REAL_TRADING=false            # ⚠️ Nunca true em dev!
MIN_CONFIDENCE=0.75                  # Score mínimo (0-1)
MAX_POSITION_SIZE=1000               # Quantidade máxima
MAX_LOSS_PER_TRADE=500               # Stop loss em R$
PROFIT_TARGET=1000                   # Alvo de lucro em R$

# === ANÁLISE ===
ANALYSIS_INTERVAL=60                 # Segundos entre ciclos
TIMEFRAME_PRIMARY=1d                 # 1m, 5m, 1h, 1d
TIMEFRAME_SECONDARY=1h
TIMEFRAME_TERTIARY=5m

# === LOGGING ===
LOG_LEVEL=INFO                       # DEBUG, INFO, WARNING, ERROR
LOG_DIR=/opt/trading-agent-b3/logs
LOG_RETENTION_DAYS=30                # Dias para manter logs
DATABASE_PATH=/opt/trading-agent-b3/data

# === ALERTAS ===
SLACK_WEBHOOK=https://hooks.slack.com/services/...
TELEGRAM_TOKEN=seu_token_telegram
TELEGRAM_CHAT_ID=seu_chat_id
EMAIL_SENDER=seu@email.com
EMAIL_PASSWORD=app_password

# === DATABASE ===
DATABASE_URL=postgresql://user:pass@localhost:5432/trading_db
REDIS_URL=redis://localhost:6379/0

# === MONITORAMENTO ===
PROMETHEUS_PORT=8000
GRAFANA_PORT=3000
ENABLE_METRICS=true
```

---

## 📊 Monitoramento e Logs {#monitoramento}

### Estrutura de Logs

```
logs/
├── trading-agent.log          # Log principal (rotativo)
├── trades.jsonl               # Histórico de trades (1 por linha)
├── errors.log                 # Erros e exceções
├── performance.log            # Métricas de performance
└── 2026-02/                   # Pasta por mês
    ├── 01.jsonl
    ├── 02.jsonl
    └── ...
```

### Analisar Logs

```bash
# Logs em tempo real
tail -f logs/trading-agent.log

# Filtrar por erro
grep ERROR logs/trading-agent.log | tail -20

# Contar eventos
cat logs/trades.jsonl | jq '.action' | sort | uniq -c

# Ver últimos 10 trades
cat logs/trades.jsonl | tail -10 | jq

# Filtrar por ativo
grep PETR4 logs/trading-agent.log

# Stats de trades
cat logs/trades.jsonl | jq '[.profit] | add'
```

---

## 🐛 Troubleshooting {#troubleshooting}

### Problema: Ollama não conecta

```bash
# Verificar se está rodando
curl http://10.41.10.151:11434/api/tags

# Se não responder, initiar
ollama serve

# Verificar modelos
ollama list
```

### Problema: Out of Memory

```bash
# Verificar uso de RAM
free -h

# Reduzir modelos em .env
OLLAMA_MODEL_STANDARD=smollm2:1.7b-instruct-q4_K_M
```

### Problema: Latência Alta (>10s)

```bash
# Medir latência de cada modelo
time ollama run deepseek-r1:8b "2+2"

# Se muito lento, usar modelos menores
OLLAMA_MODEL_REASONING=mistral:7b-instruct-q4_K_M
```

---

## ⚡ Performance Tuning {#performance}

### Otimizações de CPU

```bash
# Desativar services desnecessários
sudo systemctl disable snapd.service
sudo systemctl disable bluetooth.service

# Aumentar limites de file descriptors
echo 'fs.file-max=2097152' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Aumentar limites de processos
echo '* soft nofile 65535' | sudo tee -a /etc/security/limits.conf
echo '* hard nofile 65535' | sudo tee -a /etc/security/limits.conf
```

### Otimizações de Network

```bash
# Aumentar buffer TCP
echo 'net.core.rmem_max=134217728' | sudo tee -a /etc/sysctl.conf
echo 'net.core.wmem_max=134217728' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Reduzir latência
echo 'net.ipv4.tcp_tw_reuse=1' | sudo tee -a /etc/sysctl.conf
```

---

## 💾 Backup e Recovery {#backup}

### Backup Automático

```bash
#!/bin/bash
# /usr/local/bin/backup-trading-agent.sh

BACKUP_DIR="/mnt/backups/trading-agent"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

tar -czf $BACKUP_DIR/trading-agent-$TIMESTAMP.tar.gz \
  /opt/trading-system-agent-b3/logs \
  /opt/trading-system-agent-b3/data \
  /opt/trading-system-agent-b3/.env

# Manter últimos 30 dias
find $BACKUP_DIR -name "*.tar.gz" -mtime +30 -delete
```

### Cron Job

```bash
# Backup diário às 2AM
0 2 * * * /usr/local/bin/backup-trading-agent.sh
```

---

## 🗺️ Roadmap Futuro {#roadmap}

- [ ] Backtesting framework (histórico 5 anos)
- [ ] Live feed Nelogica Profit Pro
- [ ] Fine-tuning de prompts por ativo
- [ ] Alertas SMS/Telegram com dados
- [ ] Dashboard web (FastAPI + React)
- [ ] Mobile app (iOS/Android)
- [ ] Multi-broker support (Clear, Genial, BTG)
- [ ] GPU optimization (CUDA/Metal)
- [ ] Distributed inference (múltiplos Ollama)
- [ ] Marketplace de estratégias

---

**Documentação Técnica Completa ✅**

Próximo: Ler QUICK_START.md para setup rápido
