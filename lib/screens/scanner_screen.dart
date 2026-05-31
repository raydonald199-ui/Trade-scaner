import 'package:flutter/material.dart';
import '../models/trading_analysis.dart';
import '../services/chart_analyzer.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  late TimeframeAnalysis analysis;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalysis();
  }

  void _loadAnalysis() {
    setState(() => isLoading = true);
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          analysis = ChartAnalyzer.generateMockAnalysis();
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trade Scanner - AUDCAD'),
        subtitle: const Text('Staircase Pattern Detector'),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Analyzing Charts...'),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async => _loadAnalysis(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Multi-timeframe signal
                      _buildSignalCard(
                        title: 'Multi-Timeframe Analysis',
                        signal: analysis.multiTimeframeSignal,
                        color: analysis.allAgreed && analysis.daily.isStrongUp
                            ? Colors.green
                            : analysis.allAgreed && analysis.daily.isStrongDown
                                ? Colors.red
                                : Colors.orange,
                      ),
                      const SizedBox(height: 20),
                      // Daily timeframe
                      _buildTimeframeCard(analysis.daily),
                      const SizedBox(height: 12),
                      // Weekly timeframe
                      _buildTimeframeCard(analysis.weekly),
                      const SizedBox(height: 12),
                      // Yearly timeframe
                      _buildTimeframeCard(analysis.yearly),
                      const SizedBox(height: 20),
                      // Recommendation card
                      _buildRecommendationCard(),
                      const SizedBox(height: 20),
                      // Refresh button
                      ElevatedButton.icon(
                        onPressed: _loadAnalysis,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh Analysis'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSignalCard({
    required String title,
    required String signal,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              signal,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeframeCard(TradingAnalysis analysis) {
    final isUp = analysis.isStrongUp;
    final isDown = analysis.isStrongDown;
    final signalColor = isUp ? Colors.green : isDown ? Colors.red : Colors.grey;

    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: signalColor, width: 2),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  analysis.timeframe,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: signalColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    analysis.signal,
                    style: TextStyle(
                      color: signalColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildIndicatorRow('Close', '${analysis.closePrice.toStringAsFixed(5)}'),
            _buildIndicatorRow('SMA 9', '${analysis.sma9.toStringAsFixed(5)}'),
            _buildIndicatorRow('SMA 21', '${analysis.sma21.toStringAsFixed(5)}'),
            _buildIndicatorRow(
              'Trend Strength',
              '${(analysis.trend * 100).toStringAsFixed(1)}%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicatorRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard() {
    final mainSignal = analysis.daily;
    final recommendation = mainSignal.recommendation;
    final isUp = mainSignal.isStrongUp;
    final isDown = mainSignal.isStrongDown;
    final color = isUp ? Colors.green : isDown ? Colors.red : Colors.orange;

    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Recommendation',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              recommendation,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            if (isUp || isDown)
              Text(
                'Wait for ${isUp ? '7 days' : '3-5 days'} to see profits grow',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
