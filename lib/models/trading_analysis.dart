class TradingAnalysis {
  final String ticker;
  final String timeframe;
  final DateTime date;
  final double closePrice;
  final double sma9;
  final double sma21;
  final bool isStrongUp;
  final bool isStrongDown;
  final double trend;

  TradingAnalysis({
    required this.ticker,
    required this.timeframe,
    required this.date,
    required this.closePrice,
    required this.sma9,
    required this.sma21,
    required this.isStrongUp,
    required this.isStrongDown,
    required this.trend,
  });

  String get signal {
    if (isStrongUp) {
      return '🟢 STRONG UP';
    } else if (isStrongDown) {
      return '🔴 STRONG DOWN';
    } else {
      return '⚪ NEUTRAL';
    }
  }

  String get recommendation {
    if (isStrongUp) {
      return 'Consider BUY - Strong Uptrend Detected';
    } else if (isStrongDown) {
      return 'Consider SELL - Strong Downtrend Detected';
    } else {
      return 'HOLD - Wait for Clear Signal';
    }
  }
}

class TimeframeAnalysis {
  final TradingAnalysis daily;
  final TradingAnalysis weekly;
  final TradingAnalysis yearly;

  TimeframeAnalysis({
    required this.daily,
    required this.weekly,
    required this.yearly,
  });

  bool get allAgreed {
    final allUp = daily.isStrongUp && weekly.isStrongUp && yearly.isStrongUp;
    final allDown = daily.isStrongDown && weekly.isStrongDown && yearly.isStrongDown;
    return allUp || allDown;
  }

  String get multiTimeframeSignal {
    if (allAgreed && daily.isStrongUp) {
      return '🟢 CONFIRMED STRONG UP (All Timeframes)';
    } else if (allAgreed && daily.isStrongDown) {
      return '🔴 CONFIRMED STRONG DOWN (All Timeframes)';
    } else if (daily.isStrongUp) {
      return '🟡 UP on Daily (Check Weekly/Yearly for Confirmation)';
    } else if (daily.isStrongDown) {
      return '🟡 DOWN on Daily (Check Weekly/Yearly for Confirmation)';
    } else {
      return '⚪ No Clear Signal';
    }
  }
}
