#!/bin/bash

################################################################################
# TRADING AGENT B3 - SETUP AUTOMÁTICO
# Script que prepara 100% do ambiente
# Uso: bash SETUP_AUTOMATICO.sh
################################################################################

set -e  # Parar em qualquer erro

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # Sem cor

echo -e "${BLUE}"
echo "==============================================="
echo "  TRADING AGENT B3 - SETUP AUTOMÁTICO"
echo "==============================================="
echo -e "${NC}"

# Detectar OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
else
    echo -e "${RED}❌ SO não suportado${NC}"
    exit 1
fi

echo -e "${GREEN}✅ SO detectado: $OS${NC}"

################################################################################
# 1. PRE-REQUISITOS
################################################################################

echo -e "\n${YELLOW}1️⃣ Verificando pré-requisitos...${NC}"

# Verificar Git
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git não está instalado${NC}"
    if [ "$OS" = "linux" ]; then
        sudo apt-get install -y git
    fi
fi
echo -e "${GREEN}✅ Git OK${NC}"

# Verificar Python 3.11
if ! command -v python3.11 &> /dev/null; then
    echo -e "${RED}❌ Python 3.11 não está instalado${NC}"
    if [ "$OS" = "linux" ]; then
        sudo apt-get install -y python3.11 python3.11-venv python3.11-dev
    fi
fi
echo -e "${GREEN}✅ Python 3.11 OK${NC}"

# Verificar curl
if ! command -v curl &> /dev/null; then
    echo -e "${RED}❌ curl não está instalado${NC}"
    if [ "$OS" = "linux" ]; then
        sudo apt-get install -y curl
    fi
fi
echo -e "${GREEN}✅ curl OK${NC}"

################################################################################
# 2. ATUALIZAR SISTEMA
################################################################################

echo -e "\n${YELLOW}2️⃣ Atualizando sistema...${NC}"

if [ "$OS" = "linux" ]; then
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y build-essential htop tmux
elif [ "$OS" = "macos" ]; then
    brew update
fi

echo -e "${GREEN}✅ Sistema atualizado${NC}"

################################################################################
# 3. CRIAR DIRETÓRIOS
################################################################################

echo -e "\n${YELLOW}3️⃣ Criando diretórios...${NC}"

mkdir -p logs data config notebooks tests
echo -e "${GREEN}✅ Diretórios criados${NC}"

################################################################################
# 4. VENV PYTHON
################################################################################

echo -e "\n${YELLOW}4️⃣ Criando ambiente virtual Python...${NC}"

python3.11 -m venv venv
source venv/bin/activate

echo -e "${GREEN}✅ venv criado${NC}"

################################################################################
# 5. INSTALAR DEPENDÉNCIAS PYTHON
################################################################################

echo -e "\n${YELLOW}5️⃣ Instalando dependências Python...${NC}"

pip install --upgrade pip setuptools wheel
pip install -r requirements.txt

echo -e "${GREEN}✅ Dependências instaladas${NC}"

################################################################################
# 6. COPIAR .ENV
################################################################################

echo -e "\n${YELLOW}6️⃣ Configurando .env...${NC}"

if [ ! -f .env ]; then
    cp .env.example .env
    echo -e "${GREEN}✅ .env criado de .env.example${NC}"
    echo -e "${YELLOW}⚠️  IMPORTANTE: Edite .env com:"
    echo -e "   nano .env"
    echo -e "   - BRAPI_TOKEN (gerar em https://brapi.dev)
   - OLLAMA_HOST (10.41.10.151:11434)${NC}"
else
    echo -e "${GREEN}✅ .env já existe${NC}"
fi

################################################################################
# 7. PREPARAR LOGS
################################################################################

echo -e "\n${YELLOW}7️⃣ Preparando estrutura de logs...${NC}"

mkdir -p logs/$(date +%Y-%m)
echo -e "${GREEN}✅ Diretório de logs criado${NC}"

################################################################################
# 8. BAIXAR MODELOS OLLAMA
################################################################################

echo -e "\n${YELLOW}8️⃣ Preparando para baixar modelos Ollama...${NC}"

echo -e "${BLUE}
Os modelos ocupam ~17.5GB${NC}"
echo -e "${BLUE}Tempo estimado: 20-30 minutos${NC}"

read -p "Deseja baixar os modelos agora? (s/n) " -n 1 -r
echo

if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo -e "${YELLOW}Iniciando download dos modelos...${NC}"
    
    echo -e "${BLUE}1/5 SmolLM2 1.7B...${NC}"
    ollama pull smollm2:1.7b-instruct-q4_K_M
    echo -e "${GREEN}✅ SmolLM2${NC}"
    
    echo -e "${BLUE}2/5 Mistral 7B...${NC}"
    ollama pull mistral:7b-instruct-q4_K_M
    echo -e "${GREEN}✅ Mistral${NC}"
    
    echo -e "${BLUE}3/5 DeepSeek-R1 8B...${NC}"
    ollama pull deepseek-r1:8b
    echo -e "${GREEN}✅ DeepSeek-R1${NC}"
    
    echo -e "${BLUE}4/5 Qwen2.5-Coder 7B...${NC}"
    ollama pull qwen2.5-coder:7b-instruct-q4_K_M
    echo -e "${GREEN}✅ Qwen2.5${NC}"
    
    echo -e "${BLUE}5/5 Gemma3 4B...${NC}"
    ollama pull gemma3:4b-it
    echo -e "${GREEN}✅ Gemma3${NC}"
    
    echo -e "${GREEN}✅ Todos os modelos baixados!${NC}"
else
    echo -e "${YELLOW}Download pulado${NC}"
    echo -e "${BLUE}Para baixar depois:
    ollama pull smollm2:1.7b-instruct-q4_K_M
    ollama pull mistral:7b-instruct-q4_K_M
    ollama pull deepseek-r1:8b
    ollama pull qwen2.5-coder:7b-instruct-q4_K_M
    ollama pull gemma3:4b-it${NC}"
fi

################################################################################
# 9. VERIFICAR INSTALAÇÃO
################################################################################

echo -e "\n${YELLOW}9️⃣ Verificando instalação...${NC}"

source venv/bin/activate

# Testar imports
python3 << 'EOF'
try:
    import sys
    print(f"Python: {sys.version}")
    
    from src.models.ollama_models import OllamaModels
    print("✓ Imports OK")
    
    from src.apis.b3_api import B3API
    print("✓ B3 API OK")
except Exception as e:
    print(f"✗ Erro: {e}")
    sys.exit(1)
EOF

echo -e "${GREEN}✅ Instalação verificada${NC}"

################################################################################
# 10. MODO DE EXECUÇÃO
################################################################################

echo -e "\n${YELLOW}1️⃣  Próximos passos:${NC}"
echo -e "${BLUE}
1. Edite o arquivo .env:
   nano .env
   
   Campos obrigatórios:
   - BRAPI_TOKEN=seu_token_aqui (https://brapi.dev)
   - OLLAMA_HOST=http://10.41.10.151:11434

2. Inicie o agent:
   source venv/bin/activate
   python -m src.main

3. Verifique os logs:
   tail -f logs/trading-agent.log
${NC}"

echo -e "${GREEN}==============================================="
echo "  SETUP CONCLUÍDO COM SUCESSO!"
echo "===============================================${NC}\n"
