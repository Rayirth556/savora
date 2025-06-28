import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class TransactionsScreen extends StatefulWidget {
  final double budget;

  const TransactionsScreen({super.key, required this.budget});

  @override
  TransactionsScreenState createState() => TransactionsScreenState();
}

class TransactionsScreenState extends State<TransactionsScreen> {
  final List<String> _categories = ['Food', 'Transport', 'Shopping'];
  final TextEditingController _amountController = TextEditingController();
  String? _selectedCategory;

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
    );

    Navigator.pop(context, tx); // ✅ Return tx to Dashboard
  }

  @override
  void dispose() {
    _amountController.dispose();
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
                    onChanged: (value) =>
                        setState(() => _selectedCategory = value),
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
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitTransaction,
              child: const Text('Add Expense'),
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
}
