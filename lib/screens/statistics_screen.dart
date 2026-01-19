import 'package:flutter/material.dart';
import '../models/expense.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Expense> expenses;

  const StatisticsScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final total =
        expenses.fold(0, (sum, item) => sum + item.amount);

    final sorted = [...expenses]
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: const Text('Summary'),
                subtitle: Text('Total spent : $total'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Top Expenses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...sorted.take(3).map(
                  (e) => ListTile(
                    title: Text('${e.name} - ${e.amount}'),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
