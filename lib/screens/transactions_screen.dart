import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_sentiment_service.dart';
import '../widgets/sentiment_analysis_widget.dart';

class TransactionsScreen extends StatefulWidget {
  final double budget;
  final List<Transaction> transactionHistory;

  const TransactionsScreen({
    super.key,
    required this.budget,
    this.transactionHistory = const [],
  });

  @override
  TransactionsScreenState createState() => TransactionsScreenState();
}

class TransactionsScreenState extends State<TransactionsScreen> {
  final List<String> _categories = ['Food', 'Transport', 'Shopping'];
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  TransactionAnalysis? _currentAnalysis;

  @override
  void initState() {
    super.initState();
    // Listen for changes to predict sentiment
    _amountController.addListener(_updatePrediction);
  }

  void _updatePrediction() {
    if (_selectedCategory != null &&
        _amountController.text.isNotEmpty &&
        double.tryParse(_amountController.text) != null) {
      final amount = double.parse(_amountController.text);
      final analysis = TransactionSentimentService.predictTransactionSentiment(
        amount: amount,
        category: _selectedCategory!,
        transactionHistory: widget.transactionHistory,
        budget: widget.budget,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
      );

      setState(() {
        _currentAnalysis = analysis;
      });
    } else {
      setState(() {
        _currentAnalysis = null;
      });
    }
  }

  List<String> _getCurrentSuggestions() {
    if (_selectedCategory != null &&
        _amountController.text.isNotEmpty &&
        double.tryParse(_amountController.text) != null) {
      final amount = double.parse(_amountController.text);
      return TransactionSentimentService.getTransactionSuggestions(
        amount: amount,
        category: _selectedCategory!,
        transactionHistory: widget.transactionHistory,
        budget: widget.budget,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
      );
    }
    return [];
  }

  void _addNewCategory(String newCategory) {
    if (newCategory.isEmpty || _categories.contains(newCategory)) return;
    setState(() {
      _categories.add(newCategory);
    });
  }

  void _openAddCategoryDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add New Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Category name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _addNewCategory(controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _submitTransaction() {
    if (_selectedCategory == null || _amountController.text.isEmpty) return;

    final tx = Transaction(
      category: _selectedCategory!,
      amount: double.tryParse(_amountController.text) ?? 0,
      date: DateTime.now(),
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      analysis: _currentAnalysis, // Include the analysis
    );

    // Show warning dialog for risky transactions
    if (_currentAnalysis != null && _shouldShowWarning(_currentAnalysis!)) {
      _showTransactionWarning(tx);
    } else {
      Navigator.pop(context, tx); // ✅ Return tx to Dashboard
    }
  }

  bool _shouldShowWarning(TransactionAnalysis analysis) {
    return analysis.sentiment == TransactionSentiment.impulsive ||
        analysis.sentiment == TransactionSentiment.wasteful ||
        analysis.sentiment == TransactionSentiment.regrettable ||
        analysis.confidenceScore > 0.8;
  }

  void _showTransactionWarning(Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transaction Warning'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SentimentAnalysisWidget(
              analysis: _currentAnalysis!,
              transaction: transaction,
            ),
            const SizedBox(height: 16),
            const Text(
              'Are you sure you want to proceed with this transaction?',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, transaction); // Return transaction
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Proceed Anyway'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    hint: const Text('Select Category'),
                    onChanged: (value) {
                      setState(() => _selectedCategory = value);
                      _updatePrediction(); // Update prediction when category changes
                    },
                    items: _categories.map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _openAddCategoryDialog,
                  tooltip: 'Add new category',
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₹',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'What is this expense for?',
              ),
              onChanged: (_) =>
                  _updatePrediction(), // Update prediction when description changes
            ),
            const SizedBox(height: 24),

            // Real-time sentiment analysis prediction
            if (_currentAnalysis != null) ...[
              Card(
                color: TransactionSentimentService.getSentimentColor(
                        _currentAnalysis!.sentiment)
                    .withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getSentimentIcon(_currentAnalysis!.sentiment),
                            color:
                                TransactionSentimentService.getSentimentColor(
                                    _currentAnalysis!.sentiment),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Prediction: ${_currentAnalysis!.sentiment.name.toUpperCase()}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  TransactionSentimentService.getSentimentColor(
                                      _currentAnalysis!.sentiment),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _currentAnalysis!.reason,
                        style: const TextStyle(fontSize: 14),
                      ),
                      if (_currentAnalysis!.insights.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          '• ${_currentAnalysis!.insights.first}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Real-time suggestions
              if (_getCurrentSuggestions().isNotEmpty) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.lightbulb, color: Colors.amber),
                            SizedBox(width: 8),
                            Text(
                              'Smart Suggestions',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ..._getCurrentSuggestions().take(3).map(
                              (suggestion) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  suggestion,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],

            ElevatedButton(
              onPressed: _submitTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentAnalysis != null &&
                        _shouldShowWarning(_currentAnalysis!)
                    ? Colors.orange
                    : Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text(
                _currentAnalysis != null &&
                        _shouldShowWarning(_currentAnalysis!)
                    ? 'Add Expense (Warning!)'
                    : 'Add Expense',
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Monthly Budget: ₹${widget.budget.toStringAsFixed(0)}',
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSentimentIcon(TransactionSentiment sentiment) {
    switch (sentiment) {
      case TransactionSentiment.smart:
        return Icons.lightbulb;
      case TransactionSentiment.necessary:
        return Icons.check_circle;
      case TransactionSentiment.strategic:
        return Icons.trending_up;
      case TransactionSentiment.planned:
        return Icons.calendar_today;
      case TransactionSentiment.impulsive:
        return Icons.flash_on;
      case TransactionSentiment.emotional:
        return Icons.favorite;
      case TransactionSentiment.wasteful:
        return Icons.warning;
      case TransactionSentiment.regrettable:
        return Icons.sentiment_dissatisfied;
    }
  }
}
