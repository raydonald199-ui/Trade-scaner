class TechnicalIndicators {
  /// Calculate Simple Moving Average (SMA)
  static double calculateSMA(List<double> prices, int period) {
    if (prices.length < period) {
      return prices.isEmpty ? 0.0 : prices.last;
    }
    
    final recentPrices = prices.sublist(prices.length - period);
    final sum = recentPrices.reduce((a, b) => a + b);
    return sum / period;
  }

  /// Calculate Exponential Moving Average (EMA)
  static double calculateEMA(List<double> prices, int period) {
    if (prices.isEmpty) return 0.0;
    if (prices.length == 1) return prices.first;
    
    final multiplier = 2.0 / (period + 1);
    double ema = prices.first;
    
    for (int i = 1; i < prices.length; i++) {
      ema = (prices[i] * multiplier) + (ema * (1 - multiplier));
    }
    
    return ema;
  }

  /// Calculate RSI (Relative Strength Index)
  static double calculateRSI(List<double> prices, int period) {
    if (prices.length < period + 1) return 50.0;
    
    double gain = 0.0;
    double loss = 0.0;
    
    for (int i = 1; i <= period; i++) {
      final change = prices[prices.length - i] - prices[prices.length - i - 1];
      if (change > 0) {
        gain += change;
      } else {
        loss += change.abs();
      }
    }
    
    final avgGain = gain / period;
    final avgLoss = loss / period;
    
    if (avgLoss == 0) return 100.0;
    
    final rs = avgGain / avgLoss;
    return 100.0 - (100.0 / (1.0 + rs));
  }

  /// Calculate MACD
  static Map<String, double> calculateMACD(List<double> prices) {
    final ema12 = calculateEMA(prices, 12);
    final ema26 = calculateEMA(prices, 26);
    final macd = ema12 - ema26;
    
    return {
      'macd': macd,
      'ema12': ema12,
      'ema26': ema26,
    };
  }

  /// Detect staircase pattern
  static bool detectStaircasePattern(List<double> prices) {
    if (prices.length < 3) return false;
    
    // Check if prices are consecutively higher (staircase up)
    bool isStaircase = true;
    for (int i = 1; i < prices.length; i++) {
      if (prices[i] <= prices[i - 1]) {
        isStaircase = false;
        break;
      }
    }
    
    return isStaircase;
  }
}
