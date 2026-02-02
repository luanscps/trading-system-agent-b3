# ⚡ QUICK START - Trading Agent B3 (15 minutos)

> Guia rápido para colocar o agent rodando em 15 minutos

---

## 🚅 Passo 1: Clone e Setup (2 min)

```bash
# Clone repositório
git clone https://github.com/luanscps/trading-system-agent-b3.git
cd trading-system-agent-b3

# Crie venv
python3 -m venv venv
source venv/bin/activate  # Linux/Mac
# ou
venv\Scripts\activate  # Windows

# Instale dependências
pip install -r requirements.txt
```

---

## 🚅 Passo 2: Baixe Modelos (5-10 min) ✅ NOMES CORRETOS

```bash
# Execute no servidor com Ollama (10.41.10.151)
ollama pull smollm2:1.7b-instruct-q4_K_M
ollama pull mistral:7b-instruct-q4_K_M
ollama pull deepseek-r1:8b                    # ✅ CORRETO!
ollama pull qwen2.5-coder:7b-instruct-q4_K_M
ollama pull gemma3:4b-it                      # ✅ CORRETO!
```

**Nomes que NÃO funcionam:**
- ❌ `deepseek-r1:7b-instruct-q4_K_M` (não existe)
- ❌ `gemma3:4b` (use `gemma3:4b-it`)

---

## 🚅 Passo 3: Configure (1 min)

```bash
# Copie template
cp .env.example .env

# Edite com seu BRAPI_TOKEN
nano .env
```

**Campos obrigatórios em .env:**
```bash
BRAPI_TOKEN=seu_token_aqui
OLLAMA_HOST=http://10.41.10.151:11434
```

---

## 🚅 Passo 4: Rode! (2 min)

```bash
python -m src.main
```

**Output esperado:**
```
🚀 Trading Agent iniciado!
📈 Ollama conectado: 10.41.10.151:11434
📈 5 modelos carregados (17.5GB)
🌐 Análisando PETR4...
  ✅ SmolLM2: Sentimento BULLISH (85% confiança)
  ✅ Mistral: MACD positivo, RSI 60
  ✅ DeepSeek: Sharpe Ratio 1.2
  ✅ Qwen2.5: Dados válidos
  ✅ Gemma3: Sentimento positivo
🚀 RECOMENDAÇÃO: BUY (score: 0.87)
```

---

## 🔌 Testes Rápidos

### Verificar conexão Ollama

```bash
curl http://10.41.10.151:11434/api/tags
```

### Testar um modelo

```bash
ollama run deepseek-r1:8b "Qual é o Sharpe Ratio ideal para trading?"
```

### Verificar Python

```bash
python -c "from src.models.ollama_models import OllamaModels; print('OK')"
```

---

## 🐛 Erros Comuns

### ❌ "Model not found: deepseek-r1:7b-instruct-q4_K_M"

**Problema**: Nome errado do modelo  
**Solução**: Use `deepseek-r1:8b` (sem -instruct-q4_K_M)

```bash
# ❌ ERRADO
ollama pull deepseek-r1:7b-instruct-q4_K_M

# ✅ CORRETO
ollama pull deepseek-r1:8b
```

### ❌ "Cannot connect to Ollama"

**Problema**: Ollama não está rodando em 10.41.10.151:11434  
**Solução**: 

```bash
# Verificar se está rodando
curl http://10.41.10.151:11434/api/tags

# Se não responder, iniciar Ollama
ollama serve
```

### ❌ "Out of memory"

**Problema**: Modelos usam muita RAM  
**Solução**: Usar modelos menores em .env

```bash
# Em .env
OLLAMA_MODEL_STANDARD=smollm2:1.7b-instruct-q4_K_M
OLLAMA_MODEL_REASONING=deepseek-r1:8b  # Máximo 4.5GB
```

---

## ✅ Próximos Passos

1. **Testar em simulado**: Deixe rodando 1 hora e veja os logs
2. **Ler documentação completa**: Ver `README.md` para detalhes
3. **Deploy em produção**: Ver `DEPLOY.md` para Docker/SystemD
4. **Customizar**: Ajuste prompts e modelos em `config/`

---

## 📈 Tabela de Referência Modelos

| Modelo | Comando Ollama Correto | Tamanho | Tempo |
|--------|------------------------|---------|-------|
| SmolLM2 1.7B | `ollama pull smollm2:1.7b-instruct-q4_K_M` | 1.5GB | 300ms |
| Mistral 7B | `ollama pull mistral:7b-instruct-q4_K_M` | 4GB | 1-2s |
| DeepSeek-R1 8B | `ollama pull deepseek-r1:8b` | 4.5GB | 2-3s |
| Qwen2.5 7B | `ollama pull qwen2.5-coder:7b-instruct-q4_K_M` | 5GB | 1-2s |
| Gemma 3 4B | `ollama pull gemma3:4b-it` | 2.5GB | 800ms |

---

**Parabéns! 🎉 Seu Trading Agent está rodando!**

Próximo: Ler `README.md` para detalhes completos
