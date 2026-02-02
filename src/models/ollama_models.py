"""Interface com Ollama para análise de trading em cascata com 5 modelos IA."""

import requests
import json
import os
import logging
from typing import Dict, Optional
from dotenv import load_dotenv

load_dotenv()

logger = logging.getLogger(__name__)

class OllamaModels:
    """Wrapper para chamar diferentes modelos no Ollama.
    
    Modelos:
    1. SmolLM2 1.7B (rápido) - Análise sentimento
    2. Mistral 7B (qualidade) - Análise técnica
    3. DeepSeek-R1 7B (raciocínio) - Validação matemática
    4. Qwen2.5-Coder 7B (dados) - Processamento de dados
    5. Gemma3 4B (multimodal) - Análise de gráficos
    """
    
    def __init__(self):
        self.base_url = os.getenv("OLLAMA_HOST", "http://10.41.10.151:11434")
        self.models = {
            "fast": os.getenv("OLLAMA_MODEL_FAST", "smollm2:1.7b-instruct-q4_K_M"),
            "standard": os.getenv("OLLAMA_MODEL_STANDARD", "mistral:7b-instruct-q4_K_M"),
            "reasoning": os.getenv("OLLAMA_MODEL_REASONING", "deepseek-r1:7b-instruct-q4_K_M"),
            "coder": os.getenv("OLLAMA_MODEL_CODER", "qwen2.5-coder:7b-instruct-q4_K_M"),
            "vision": os.getenv("OLLAMA_MODEL_VISION", "gemma3:4b-it"),
        }
    
    def analyze_sentiment(self, text: str) -> Dict:
        """Análise rápida de sentimento (SmolLM2 - 300-500ms).
        
        Args:
            text: Texto/notícia a analisar
            
        Returns:
            Dict com sentimento e confiança
        """
        prompt = f"""Analise o sentimento desta notícia financeira (responda em JSON):

Notícia: {text}

Responda em JSON (sem markdown):
{{
    "sentimento": "alta|média|baixa",
    "confiança": 0-100,
    "ativos_afetados": ["PETR4", "VALE3"],
    "recomendação": "COMPRAR|MANTER|VENDER"
}}"""
        
        try:
            response = requests.post(
                f"{self.base_url}/api/generate",
                json={
                    "model": self.models["fast"],
                    "prompt": prompt,
                    "stream": False,
                    "temperature": 0.3
                },
                timeout=30
            )
            response.raise_for_status()
            result = response.json()
            
            # Tentar fazer parse de JSON
            try:
                return json.loads(result['response'])
            except:
                return {"raw": result['response']}
        except Exception as e:
            logger.error(f"Erro na análise de sentimento: {e}")
            return {"erro": str(e)}
    
    def analyze_technical(self, ohlcv_data: str) -> Dict:
        """Análise técnica detalhada (Mistral 7B - 1-2s).
        
        Args:
            ohlcv_data: Dados OHLCV em formato texto
            
        Returns:
            Dict com tendência, suporte/resistência, sinais
        """
        prompt = f"""Analise esta série de preços (OHLCV):

{ohlcv_data}

Responda em JSON (sem markdown):
{{
    "tendencia": "alta|baixa|lateral",
    "suporte": 27.30,
    "resistencia": 28.10,
    "sinal": "COMPRAR|VENDER|AGUARDAR",
    "forca": 0-100
}}"""
        
        try:
            response = requests.post(
                f"{self.base_url}/api/generate",
                json={
                    "model": self.models["standard"],
                    "prompt": prompt,
                    "stream": False,
                    "temperature": 0.2
                },
                timeout=60
            )
            response.raise_for_status()
            result = response.json()
            return {"analysis": result['response']}
        except Exception as e:
            logger.error(f"Erro na análise técnica: {e}")
            return {"erro": str(e)}
    
    def validate_strategy(self, strategy_logic: str) -> Dict:
        """Validação matemática de estratégia (DeepSeek-R1 - 2-3s).
        
        Args:
            strategy_logic: Lógica da estratégia
            
        Returns:
            Dict com validação e metrícas
        """
        prompt = f"""Valide matematicamente esta estratégia de trading:

{strategy_logic}

Análise:
1. Está matematicamente correta?
2. Riscos lógicos?
3. Otimizações possíveis?
4. Qual o Sharpe Ratio teórico?
5. Confiança geral (0-100)?

Responda em JSON."""
        
        try:
            response = requests.post(
                f"{self.base_url}/api/generate",
                json={
                    "model": self.models["reasoning"],
                    "prompt": prompt,
                    "stream": False,
                },
                timeout=90
            )
            response.raise_for_status()
            result = response.json()
            return {"reasoning": result['response']}
        except Exception as e:
            logger.error(f"Erro na validação: {e}")
            return {"erro": str(e)}
    
    def process_data(self, code: str) -> Dict:
        """Processamento de dados (Qwen2.5-Coder - 1-2s).
        
        Args:
            code: Código ou lógica a processar
            
        Returns:
            Dict com resultado do processamento
        """
        prompt = f"""Execute este processamento de dados:

{code}

Retorne o resultado formatado."""
        
        try:
            response = requests.post(
                f"{self.base_url}/api/generate",
                json={
                    "model": self.models["coder"],
                    "prompt": prompt,
                    "stream": False,
                },
                timeout=60
            )
            response.raise_for_status()
            result = response.json()
            return {"result": result['response']}
        except Exception as e:
            logger.error(f"Erro no processamento: {e}")
            return {"erro": str(e)}
    
    def analyze_chart(self, image_base64: str, question: str) -> Dict:
        """Análise de gráfico (Gemma3 4B multimodal - 2-4s).
        
        Args:
            image_base64: Imagem codificada em base64
            question: Pergunta sobre a imagem
            
        Returns:
            Dict com análise da imagem
        """
        try:
            response = requests.post(
                f"{self.base_url}/api/generate",
                json={
                    "model": self.models["vision"],
                    "prompt": question,
                    "images": [image_base64],
                    "stream": False,
                },
                timeout=60
            )
            response.raise_for_status()
            result = response.json()
            return {"analysis": result['response']}
        except Exception as e:
            logger.error(f"Erro na análise de imagem: {e}")
            return {"erro": str(e)}


if __name__ == "__main__":
    ollama = OllamaModels()
    
    # Teste 1: Sentimento (SmolLM2)
    print("1️⃣ Teste Sentimento...")
    resultado = ollama.analyze_sentiment("SELIC sobe para 11.25%, maior em 2 anos")
    print(f"Resultado: {resultado}\n")
    
    # Teste 2: Técnica (Mistral)
    print("2️⃣ Teste Técnica...")
    ohlcv = "Data: 2026-02-01, Open: 27.50, High: 27.80, Low: 27.45, Close: 27.75, Volume: 1200000"
    resultado = ollama.analyze_technical(ohlcv)
    print(f"Resultado: {resultado}\n")
    
    print("✅ Testes concluídos!")
