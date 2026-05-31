import '../models/trading_analysis.dart';
import '../utils/indicators.dart';

class ChartAnalyzer {
  static const String ticker = 'AUDCAD=X';

  /// Analyze price data for staircase patterns
  static TradingAnalysis analyze({
    required List<double> closePrices,
    required String timeframe,
    required DateTime lastDate,
  }) {
    // Calculate moving averages
    final sma9 = TechnicalIndicators.calculateSMA(closePrices, 9);
    final sma21 = TechnicalIndicators.calculateSMA(closePrices, 21);
    
    final currentClose = closePrices.last;
    
    // Check for strong uptrend: Close > SMA9 > SMA21
    final isStrongUp = currentClose > sma9 && sma9 > sma21;
    
    // Check for strong downtrend: Close < SMA9 < SMA21
    final isStrongDown = currentClose < sma9 && sma9 < sma21;
    
    // Calculate trend strength
    final trend = _calculateTrendStrength(closePrices, sma9, sma21);
    
    return TradingAnalysis(
      ticker: ticker,
      timeframe: timeframe,
      date: lastDate,
      closePrice: currentClose,
      sma9: sma9,
      sma21: sma21,
      isStrongUp: isStrongUp,
      isStrongDown: isStrongDown,
      trend: trend,
    );
  }

  /// Calculate trend strength (0.0 to 1.0)
  static double _calculateTrendStrength(List<double> prices, double sma9, double sma21) {
    if (prices.isEmpty) return 0.0;
    
    final currentPrice = prices.last;
    final distance = (currentPrice - sma21).abs();
    final maxDistance = sma21 * 0.05; // 5% of SMA21 as reference
    
    return (distance / maxDistance).clamp(0.0, 1.0);
  }

  /// Generate mock data for demonstration
  static TimeframeAnalysis generateMockAnalysis() {
    // Mock daily data - Strong uptrend
    final dailyPrices = List<double>.generate(50, (i) => 0.8800 + (i * 0.0005));
    final daily = analyze(
      closePrices: dailyPrices,
      timeframe: 'Daily',
      lastDate: DateTime.now(),
    );

    // Mock weekly data - Strong uptrend
    final weeklyPrices = List<double>.generate(20, (i) => 0.8600 + (i * 0.002));
    final weekly = analyze(
      closePrices: weeklyPrices,
      timeframe: 'Weekly',
      lastDate: DateTime.now().subtract(Duration(days: 7)),
    );

    // Mock yearly data - Uptrend
    final yearlyPrices = List<double>.generate(12, (i) => 0.8300 + (i * 0.004));
    final yearly = analyze(
      closePrices: yearlyPrices,
      timeframe: 'Yearly',
      lastDate: DateTime.now().subtract(Duration(days: 365)),
    );

    return TimeframeAnalysis(
      daily: daily,
      weekly: weekly,
      yearly: yearly,
    );
  }
}
