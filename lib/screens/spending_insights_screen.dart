import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../widgets/spending_charts.dart';


class SpendingInsightsScreen extends StatelessWidget {
  const SpendingInsightsScreen({super.key});

  // Temporary mock data
  List<Transaction> _mockTransactions() {
    return [
      Transaction(category: 'Food', amount: 500, date: DateTime.now()),
      Transaction(category: 'Transport', amount: 200, date: DateTime.now()),
      Transaction(category: 'Entertainment', amount: 300, date: DateTime.now()),
      Transaction(category: 'Food', amount: 150, date: DateTime.now()),
    ];
  }

  Map<String, double> _groupByCategory(List<Transaction> transactions) {
    final Map<String, double> grouped = {};
    for (var t in transactions) {
      grouped[t.category] = (grouped[t.category] ?? 0) + t.amount;
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final transactions = _mockTransactions();
    final data = _groupByCategory(transactions);

    return Scaffold(
      appBar: AppBar(title: const Text('Spending Insights')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Pie Chart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 200, child: SpendingPieChart(data: data)),
            const SizedBox(height: 20),
            const Text('Bar Chart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 200, child: SpendingBarChart(data: data)),
          ],
        ),
      ),
    );
  }
}

