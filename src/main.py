"""Trading Agent Principal - Loop autônomo 24/7 de análise em cascata."""

import os
import time
import json
import logging
from datetime import datetime
from dotenv import load_dotenv

from src.models.ollama_models import OllamaModels
from src.apis.b3_api import B3API

# Setup Logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('logs/trading-agent.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

load_dotenv()

class TradingAgent:
    """Agente de Trading Autônomo com análise em cascata."""
    
    def __init__(self):
        self.ollama = OllamaModels()
        self.b3 = B3API()
        self.tickers = ["PETR4", "VALE3", "ITUB4", "BBDC4"]
        self.cycle = 0
        logger.info("🚀 Trading Agent iniciado!")
    
    def run_sentiment_analysis(self) -> dict:
        """Nível 1: Análise de Sentimento (SmolLM2 - RÁPIDO)."""
        logger.info("1️⃣ Analisando sentimento de mercado...")
        
        noticias = {
            "SELIC sobe para 11.25%, maior em 2 anos": "MACRO",
            "Petrobrás lucra R$ 12 bilhões no trimestre": "PETR4",
            "Vale minera anuncia novos projetos": "VALE3"
        }
        
        sentiment_results = []
        for noticia, ativo in noticias.items():
            resultado = self.ollama.analyze_sentiment(noticia)
            logger.info(f"Sentimento [{ativo}]: {resultado}")
            sentiment_results.append({"ativo": ativo, "resultado": resultado})
        
        return sentiment_results
    
    def run_technical_analysis(self, ticker: str, sentiment: str = None) -> dict:
        """Nível 2: Análise Técnica (Mistral 7B - DETALHADO)."""
        logger.info(f"2️⃣ Analisando técnica de {ticker}...")
        
        df = self.b3.get_historical(ticker, range_type="1mo")
        
        if df.empty:
            logger.warning(f"Sem dados para {ticker}")
            return {"erro": "Sem dados"}
        
        ohlcv_text = df.tail(20).to_string()
        resultado = self.ollama.analyze_technical(ohlcv_text)
        logger.info(f"Técnica {ticker}: {resultado}")
        
        return resultado
    
    def run_strategy_validation(self, ticker: str, technical: dict) -> dict:
        """Nível 3: Validação de Estratégia (DeepSeek-R1 - RACIOCÍNIO)."""
        logger.info(f"3️⃣ Validando estratégia para {ticker}...")
        
        strategy_logic = f"""
        Ativo: {ticker}
        Análise Técnica: {json.dumps(technical)}
        
        Estratégia:
        - Se tendência ALTA: COMPRAR
        - Se tendência BAIXA: VENDER
        - RR esperado: 2:1
        - Stop Loss: 2% abaixo da entrada
        - Take Profit: 4% acima da entrada
        """
        
        resultado = self.ollama.validate_strategy(strategy_logic)
        logger.info(f"Validação {ticker}: {resultado}")
        
        return resultado
    
    def execute_trade_if_high_confidence(self, ticker: str, confidence: float = 0.85) -> None:
        """Nível 4: Executar Trade se Confiança > Threshold."""
        min_confidence = float(os.getenv("MIN_CONFIDENCE", 0.75))
        
        logger.info(f"Confiança {ticker}: {confidence} (threshold: {min_confidence})")
        
        if confidence > min_confidence:
            logger.warning(f"🚨 SINAL DE COMPRA {ticker} - Confiança: {confidence}")
            self.log_trade_decision(ticker, "COMPRAR", confidence)
        else:
            logger.info(f"Confiança baixa {ticker}: {confidence}. Aguardando...")
    
    def log_trade_decision(self, ticker: str, decision: str, confidence: float) -> None:
        """Log de decisão de trade."""
        log_entry = {
            "timestamp": datetime.now().isoformat(),
            "cycle": self.cycle,
            "ticker": ticker,
            "decision": decision,
            "confidence": confidence,
            "status": "SIMULADO"
        }
        
        logger.info(f"TRADE DECISION: {json.dumps(log_entry)}")
        
        # Salvar em arquivo JSONL
        os.makedirs("logs", exist_ok=True)
        with open('logs/trades.jsonl', 'a') as f:
            f.write(json.dumps(log_entry) + '\n')
    
    def run_loop(self, interval_seconds: int = 60) -> None:
        """Loop principal de trading."""
        logger.info("🚀 Trading Agent rodando em modo SIMULADO...")
        
        try:
            while True:
                self.cycle += 1
                logger.info(f"\n{'='*60}")
                logger.info(f"Ciclo #{self.cycle} - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
                logger.info(f"{'='*60}\n")
                
                # Executar análise em cascata
                self.run_sentiment_analysis()
                
                # Análise técnica para primeiro ticker
                for ticker in self.tickers[:1]:
                    technical = self.run_technical_analysis(ticker)
                    if "erro" not in technical:
                        self.run_strategy_validation(ticker, technical)
                        self.execute_trade_if_high_confidence(ticker, confidence=0.85)
                
                logger.info(f"\nPróximo ciclo em {interval_seconds}s...\n")
                time.sleep(interval_seconds)
        
        except KeyboardInterrupt:
            logger.info("⚠️ Trading Agent parado pelo usuário.")
        except Exception as e:
            logger.error(f"❌ Erro no agent: {e}", exc_info=True)
            raise


if __name__ == "__main__":
    # Criar pasta de logs
    os.makedirs("logs", exist_ok=True)
    
    # Iniciar agent
    agent = TradingAgent()
    
    # Rodar a cada 60 segundos (customizável)
    interval = int(os.getenv("ANALYSIS_INTERVAL", 60))
    agent.run_loop(interval_seconds=interval)
