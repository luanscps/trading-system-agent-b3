"""Trading System Agent B3 - Sistema autônomo de análise financeira com Ollama LLM"""

__version__ = "1.0.0"
__author__ = "Luan"
__email__ = "luanscps@gmail.com"
__description__ = "Trading Agent com 5 modelos IA em cascata para análise B3 24/7"

from src.apis.b3_api import B3API
from src.models.ollama_models import OllamaModels

__all__ = ["B3API", "OllamaModels"]
