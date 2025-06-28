import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'transactions_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final List<Transaction> initialTransactions;
  final double budget;

  const TransactionHistoryScreen({
    super.key,
    required this.initialTransactions,
    required this.budget,
  });

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late List<Transaction> _transactions;

  @override
  void initState() {
    super.initState();
    _transactions = List.from(widget.initialTransactions);
  }

  void _addTransaction(Transaction tx) {
    setState(() {
      _transactions.add(tx);
    });
  }

  void _openTransactionForm() async {
    final newTx = await Navigator.push<Transaction>(
      context,
      MaterialPageRoute(
        builder: (_) => TransactionsScreen(budget: widget.budget),
      ),
    );

    if (newTx != null) {
      _addTransaction(newTx);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        // Only manually return transactions if system back gesture didn't handle it
        if (!didPop) {
          Navigator.pop(context, _transactions);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Transactions'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, _transactions);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openTransactionForm,
          child: const Icon(Icons.add),
        ),
        body: _transactions.isEmpty
            ? const Center(child: Text('No transactions added yet.'))
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final tx = _transactions[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.category),
                      title: Text(tx.category),
                      subtitle: Text(
                        '${tx.date.day}/${tx.date.month}/${tx.date.year}',
                      ),
                      trailing: Text('₹${tx.amount.toStringAsFixed(2)}'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
