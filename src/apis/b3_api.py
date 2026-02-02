"""API B3 via brapi.dev - Cotações em tempo real e histórico OHLCV."""

import requests
import pandas as pd
import os
from typing import Dict, List, Optional
import logging

logger = logging.getLogger(__name__)

class B3API:
    """Interface com B3 via brapi.dev (API gratuita)."""
    
    def __init__(self):
        self.base_url = os.getenv("BRAPI_URL", "https://brapi.dev/api")
        self.token = os.getenv("BRAPI_TOKEN", "")
        self.headers = {"Authorization": f"Bearer {self.token}"} if self.token else {}
    
    def get_quote(self, ticker: str) -> Dict:
        """Obter cotação atual de um ativo.
        
        Args:
            ticker: Código do ativo (ex: "PETR4")
            
        Returns:
            Dict com dados da cotação
        """
        url = f"{self.base_url}/quote/{ticker}"
        try:
            response = requests.get(url, headers=self.headers, timeout=10)
            response.raise_for_status()
            return response.json()
        except Exception as e:
            logger.error(f"Erro ao buscar {ticker}: {e}")
            return {"erro": str(e)}
    
    def get_quotes_multiple(self, tickers: List[str]) -> Dict:
        """Obter múltiplas cotações em uma requisição.
        
        Args:
            tickers: Lista de códigos (ex: ["PETR4", "VALE3"])
            
        Returns:
            Dict com cotações de todos os ativos
        """
        tickers_str = ",".join(tickers)
        url = f"{self.base_url}/quote/{tickers_str}"
        try:
            response = requests.get(url, headers=self.headers, timeout=10)
            response.raise_for_status()
            return response.json()
        except Exception as e:
            logger.error(f"Erro ao buscar múltiplos: {e}")
            return {"erro": str(e)}
    
    def get_historical(self, ticker: str, range_type: str = "1mo") -> pd.DataFrame:
        """Obter dados históricos OHLCV.
        
        Args:
            ticker: Código do ativo
            range_type: Período ("1d", "5d", "1mo", "3mo", "6mo", "1y", "5y", "max")
            
        Returns:
            DataFrame com OHLCV
        """
        url = f"{self.base_url}/quote/{ticker}?range={range_type}&interval=1d"
        try:
            response = requests.get(url, headers=self.headers, timeout=30)
            response.raise_for_status()
            data = response.json()
            
            if 'results' in data and len(data['results']) > 0:
                historical = data['results'][0].get('historicalDataPrice', [])
                df = pd.DataFrame(historical)
                df['date'] = pd.to_datetime(df['date'])
                df = df.sort_values('date')
                return df
            
            return pd.DataFrame()
        except Exception as e:
            logger.error(f"Erro ao buscar histórico {ticker}: {e}")
            return pd.DataFrame()
    
    def get_top_gainers(self, limit: int = 10) -> List[Dict]:
        """Obter top ativos em alta.
        
        Args:
            limit: Quantidade de ativos (padrão: 10)
            
        Returns:
            Lista com top ativos
        """
        url = f"{self.base_url}/quote/list?top={limit}&type=winners"
        try:
            response = requests.get(url, headers=self.headers, timeout=10)
            response.raise_for_status()
            return response.json().get('stocks', [])
        except Exception as e:
            logger.error(f"Erro ao buscar top gainers: {e}")
            return []
    
    def get_top_losers(self, limit: int = 10) -> List[Dict]:
        """Obter top ativos em baixa.
        
        Args:
            limit: Quantidade de ativos (padrão: 10)
            
        Returns:
            Lista com top ativos
        """
        url = f"{self.base_url}/quote/list?top={limit}&type=losers"
        try:
            response = requests.get(url, headers=self.headers, timeout=10)
            response.raise_for_status()
            return response.json().get('stocks', [])
        except Exception as e:
            logger.error(f"Erro ao buscar top losers: {e}")
            return []
    
    def get_selic_rate(self) -> Dict:
        """Obter taxa SELIC atual.
        
        Returns:
            Dict com taxa SELIC
        """
        url = f"{self.base_url}/v2/prime-rate"
        try:
            response = requests.get(url, headers=self.headers, timeout=10)
            response.raise_for_status()
            return response.json()
        except Exception as e:
            logger.error(f"Erro ao buscar SELIC: {e}")
            return {"erro": str(e)}
    
    def get_currency(self, currency: str = "USD") -> Dict:
        """Obter cotação de moeda.
        
        Args:
            currency: Moeda ("USD", "EUR", "GBP")
            
        Returns:
            Dict com cotação da moeda
        """
        url = f"{self.base_url}/v2/currency?currency={currency}"
        try:
            response = requests.get(url, headers=self.headers, timeout=10)
            response.raise_for_status()
            return response.json()
        except Exception as e:
            logger.error(f"Erro ao buscar {currency}: {e}")
            return {"erro": str(e)}


if __name__ == "__main__":
    # Teste rápido
    b3 = B3API()
    
    print("=== Cotação PETR4 ===")
    quote = b3.get_quote("PETR4")
    print(quote)
    
    print("\n=== Histórico VALE3 (30 dias) ===")
    df = b3.get_historical("VALE3", "1mo")
    print(df.tail())
    
    print("\n=== Taxa SELIC ===")
    selic = b3.get_selic_rate()
    print(selic)
