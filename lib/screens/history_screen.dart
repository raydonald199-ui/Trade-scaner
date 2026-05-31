import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis History'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('AUDCAD - ${DateTime.now().subtract(Duration(days: index)).toString().split(' ')[0]}'),
            subtitle: const Text('Strong Up Pattern Detected'),
            trailing: const Icon(Icons.arrow_forward),
            leading: const Icon(Icons.trending_up, color: Colors.green),
          );
        },
      ),
    );
  }
}
