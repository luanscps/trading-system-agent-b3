# ⚡ QUICK START - Trading Agent B3 (15 minutos)

## 🎯 Objetivo

Rodar um Trading Agent local que analisa notícias, dados técnicos e executa trades com 4 modelos Ollama diferentes em cascata.

---

## 📄 PRÉ-REQUISITOS

✅ Docker running em `10.41.10.151:11434` (Ollama)  
✅ Python 3.11+ instalado  
✅ ~45GB RAM disponível  
✅ ~20GB espaço em disco livre  

---

## 🚀 PASSO 1: CLONE E SETUP (2 min)

```bash
# Clonar repositório
git clone https://github.com/luanscps/trading-system-agent-b3.git
cd trading-system-agent-b3

# Criar venv
python3 -m venv venv
source venv/bin/activate

# Instalar dependências
pip install -r requirements.txt
```

---

## 📄 PASSO 2: BAIXAR MODELOS (15-20 min)

### No servidor com Ollama (10.41.10.151)

```bash
# SSH para o servidor
ssh user@10.41.10.151

# Baixar modelos
docker exec ollama-mistral bash << 'EOF'
echo "📥 Baixando modelos..."
ollama pull smollm2:1.7b-instruct-q4_K_M
ollama pull mistral:7b-instruct-q4_K_M
ollama pull deepseek-r1:7b-instruct-q4_K_M
ollama pull qwen2.5-coder:7b-instruct-q4_K_M
ollama pull gemma3:4b-it
echo "✅ Modelos baixados!"
ollama list
EOF
```

**Tempo**: ~20-30 minutos (depende internet)

---

## ⚙️ PASSO 3: CONFIGURAR CREDENCIAIS

```bash
# Copiar template
cp .env.example .env

# Editar com seus dados
nano .env

# Campos obrigatórios:
# BRAPI_TOKEN=seu_token  (gerar em https://brapi.dev - GRATUITO)
# OLLAMA_HOST=http://10.41.10.151:11434
```

---

## ✅ PASSO 4: RODAR AGENT

### Modo Desenvolvimento (Terminal)

```bash
source venv/bin/activate
python -m src.main

# Output esperado:
# 🚀 Trading Agent iniciado!
# 1️⃣ Analisando sentimento...
# 2️⃣ Analisando técnica...
# 3️⃣ Validando estratégia...
```

### Modo Produção (Docker)

```bash
# Build
docker build -t trading-agent-b3:latest .

# Run
docker run -d \
  --name trading-agent \
  -v $(pwd)/logs:/app/logs \
  --network host \
  --env-file .env \
  trading-agent-b3:latest

# Logs
docker logs -f trading-agent
```

---

## 📈 PASSO 5: MONITORAR

```bash
# Logs em tempo real
tail -f logs/trading-agent.log

# Trades executados
cat logs/trades.jsonl | tail -20

# Filtrar por ticker
grep "PETR4" logs/trading-agent.log
```

---

## 🔧 Troubleshooting Rápido

### Erro: "Cannot connect to Ollama"

```bash
# Verificar
docker exec ollama-mistral ollama list

# Reiniciar
docker restart ollama-mistral
```

### Erro: "ModuleNotFoundError"

```bash
source venv/bin/activate
pip install -r requirements.txt
```

### Erro: "Out of memory"

```bash
# Usar modelo menor em .env
OLLAMA_MODEL_STANDARD=smollm2:1.7b-instruct-q4_K_M
```

---

## 📈 Performance Esperada

- **Latência**: ~5-10 segundos/ciclo
- **Throughput**: ~1 ciclo/minuto
- **Uptime**: 99.9%
- **Custo**: R$ 0,00

---

## ⭐ Próximos Passos

1. Editar prompts em `config/prompts.yaml`
2. Integrar broker real em `src/apis/broker_api.py`
3. Testar backtesting
4. Fine-tuning de parâmetros

---

**Tempo total**: ~30-40 minutos (primeira vez)

Documentação completa em [README.md](README.md)
