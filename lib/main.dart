import 'package:flutter/material.dart';
import 'screens/scanner_screen.dart';

void main() {
  runApp(const TradeScrollerApp());
}

class TradeScrollerApp extends StatelessWidget {
  const TradeScrollerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trade Scanner - Staircase Patterns',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ScannerScreen(),
    );
  }
}
