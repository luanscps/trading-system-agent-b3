# 🧠 Modelos Ollama - Guia Completo

> Documentação dos 5 modelos usados no Trading Agent com nomes CORRETOS e verificados

---

## ❌ EM 01/02/2026 ESSES MODELOS NÃO EXISTEM

```bash
# ❌ NÃO USE ESSES NOMES
ollama pull deepseek-r1:7b-instruct-q4_K_M   # NÃO FUNCIONA
ollama pull gemma3:4b                        # USA gemma3:4b-it INSTEAD
```

---

## ✅ MODELOS CORRETOS (01/02/2026)

### 1. SmolLM2 1.7B - Análise Rápida

**Nome Correto:**
```bash
ollama pull smollm2:1.7b-instruct-q4_K_M
```

**Especificações:**
- **Tamanho**: 1.5GB
- **Latência**: 300-500ms
- **Uso**: Sentimento rápido, classificação rápida
- **GPU**: Não obrigatório
- **Status**: ✅ Funcional (verificado em 01/02/2026)

**Rodar:**
```bash
ollama run smollm2:1.7b-instruct-q4_K_M
```

---

### 2. Mistral 7B - Análise Detalhada

**Nome Correto:**
```bash
ollama pull mistral:7b-instruct-q4_K_M
```

**Especificações:**
- **Tamanho**: 4GB
- **Latência**: 1-2 segundos
- **Uso**: Análise técnica detalhada, interpretação gráficos
- **GPU**: Recomendado 8GB VRAM
- **Status**: ✅ Funcional (verificado em 01/02/2026)

**Rodar:**
```bash
ollama run mistral:7b-instruct-q4_K_M
```

---

### 3. DeepSeek-R1 8B - Raciocínio Matemático 🎯 CRÍTICO

**Nome CORRETO (não 7B):**
```bash
ollama pull deepseek-r1:8b
```

**Especificações:**
- **Tamanho**: 4.5GB
- **Latência**: 2-3 segundos
- **Uso**: Cálculo Sharpe Ratio, validação matemática
- **GPU**: Recomendado 8GB VRAM
- **Status**: ✅ Funcional (verificado em 01/02/2026)
- **AVISO**: Não existe versão 7B com quantização `-instruct-q4_K_M`

**Rodar:**
```bash
ollama run deepseek-r1:8b
```

**Alternativas (se 8B for lento):**
```bash
# Para máquinas com más resources
ollama pull deepseek-r1:7b          # Versão menor (se existir)
# ou
ollama pull mistral:7b-instruct-q4_K_M  # Fallback para Mistral
```

---

### 4. Qwen2.5-Coder 7B - Processamento de Dados

**Nome Correto:**
```bash
ollama pull qwen2.5-coder:7b-instruct-q4_K_M
```

**Especificações:**
- **Tamanho**: 5GB
- **Latência**: 1-2 segundos
- **Uso**: Processamento de scripts, análise de dados, geração de código
- **GPU**: Recomendado 8GB VRAM
- **Status**: ✅ Funcional (verificado em 01/02/2026)

**Rodar:**
```bash
ollama run qwen2.5-coder:7b-instruct-q4_K_M
```

---

### 5. Gemma 3 4B - Análise Multimodal 🎯 CRÍTICO

**Nome CORRETO (com `-it`):**
```bash
ollama pull gemma3:4b-it
```

**Especificações:**
- **Tamanho**: 2.5GB
- **Latência**: 800ms
- **Uso**: Análise de sentimento, suporte multimodal (texto + imagens)
- **GPU**: Recomendado 6GB VRAM
- **Status**: ✅ Funcional (verificado em 01/02/2026)
- **AVISO**: Não use `gemma3:4b` (use `gemma3:4b-it`)

**Rodar:**
```bash
ollama run gemma3:4b-it
```

**Opções Gemma 3 disponíveis:**
```bash
ollama pull gemma3:270m    # Ultra-leve (32KB context)
ollama pull gemma3:1b      # Muito leve (32K context)
ollama pull gemma3:4b-it   # ✅ RECOMENDADO (128K context)
ollama pull gemma3:12b     # Mais poderoso (128K context)
ollama pull gemma3:27b     # Very large (128K context)
```

---

## 📃 Resumo dos Nomes Corretos

| # | Modelo | Nome Ollama Correto | ❌ ERRADO | Tamanho |
|---|--------|---------------------|----------|----------|
| 1 | SmolLM2 1.7B | `smollm2:1.7b-instruct-q4_K_M` | N/A | 1.5GB |
| 2 | Mistral 7B | `mistral:7b-instruct-q4_K_M` | N/A | 4GB |
| 3 | DeepSeek-R1 8B | `deepseek-r1:8b` | `deepseek-r1:7b-instruct-q4_K_M` | 4.5GB |
| 4 | Qwen2.5 7B | `qwen2.5-coder:7b-instruct-q4_K_M` | N/A | 5GB |
| 5 | Gemma 3 4B | `gemma3:4b-it` | `gemma3:4b` | 2.5GB |

**Total**: 17.5GB em disco

---

## 🚅 Como Baixar Todos (Correto)

```bash
#!/bin/bash
# Script para baixar TODOS os modelos com nomes corretos

echo "🚅 Baixando 5 modelos para Trading Agent..."

ollama pull smollm2:1.7b-instruct-q4_K_M
echo "✅ SmolLM2 1.7B"

ollama pull mistral:7b-instruct-q4_K_M
echo "✅ Mistral 7B"

ollama pull deepseek-r1:8b
echo "✅ DeepSeek-R1 8B"

ollama pull qwen2.5-coder:7b-instruct-q4_K_M
echo "✅ Qwen2.5-Coder 7B"

ollama pull gemma3:4b-it
echo "✅ Gemma 3 4B"

echo "🚀 Concluído! 17.5GB baixados"
ollama list
```

---

## 🐛 Problemas Comuns

### Erro: "Model not found: deepseek-r1:7b-instruct-q4_K_M"

**Causa**: Nome errado (7B com quantização não existe)  
**Solução**: Use `deepseek-r1:8b`

```bash
# ❌ ERRADO
ollama pull deepseek-r1:7b-instruct-q4_K_M

# ✅ CORRETO
ollama pull deepseek-r1:8b
```

### Erro: "Model not found: gemma3:4b"

**Causa**: Nome incompleto (falta `-it`)  
**Solução**: Use `gemma3:4b-it`

```bash
# ❌ ERRADO
ollama pull gemma3:4b

# ✅ CORRETO
ollama pull gemma3:4b-it
```

### Verificar Modelos Instalados

```bash
ollama list
```

**Saída esperada:**
```
NAME                               ID              SIZE      MODIFIED
smollm2:1.7b-instruct-q4_K_M      abcd1234...     1.5GB     2 hours ago
mistral:7b-instruct-q4_K_M        efgh5678...     4.0GB     2 hours ago
deepseek-r1:8b                    ijkl9012...     4.5GB     2 hours ago
qwen2.5-coder:7b-instruct-q4_K_M  mnop3456...     5.0GB     2 hours ago
gemma3:4b-it                       qrst7890...     2.5GB     2 hours ago
```

---

## 🌐 Fonte de Verificação

- [Ollama Model Library](https://ollama.com/library)
- [DeepSeek-R1 no Ollama](https://ollama.com/library/deepseek-r1)
- [Gemma 3 no Ollama](https://ollama.com/library/gemma3)

**Última verificação**: 01/02/2026

---

## 📝 Referência Rápida (.env)

```bash
# Nomes corretos para .env
OLLAMA_MODEL_FAST=smollm2:1.7b-instruct-q4_K_M
OLLAMA_MODEL_STANDARD=mistral:7b-instruct-q4_K_M
OLLAMA_MODEL_REASONING=deepseek-r1:8b
OLLAMA_MODEL_CODER=qwen2.5-coder:7b-instruct-q4_K_M
OLLAMA_MODEL_SENTIMENT=gemma3:4b-it
```

---

**🚀 Use esses nomes exatos ou falhará!**
