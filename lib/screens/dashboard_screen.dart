import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';
import 'transaction_history_screen.dart';
import '../widgets/spending_charts.dart';
import '../widgets/wallet_card.dart';
import '../theme/savora_theme.dart';
import '../widgets/sentiment_dashboard_widget.dart';
import '../services/stock_market_service.dart';

class DashboardScreen extends StatefulWidget {
  final String userName;
  final String? profileImagePath;
  final Function(String imagePath)? onImageUpdated;

  const DashboardScreen({
    super.key,
    required this.userName,
    this.profileImagePath,
    this.onImageUpdated,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double _walletBalance = 0.0;
  final int userXP = 120;
  final int streak = 3;
  double userBudget = 2000;
  final TextEditingController _budgetController = TextEditingController();
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _loadWalletBalance();
  }

  Future<void> _loadWalletBalance() async {
    final balance = await StockMarketService().getWalletBalance();
    if (mounted) {
      setState(() {
        _walletBalance = balance;
      });
    }
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('transactions');
    if (stored != null) {
      final decoded = jsonDecode(stored) as List;
      setState(() {
        _transactions = decoded.map((e) => Transaction.fromJson(e)).toList();
      });
    }
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_transactions.map((e) => e.toJson()).toList());
    await prefs.setString('transactions', encoded);
  }

  Map<String, double> _groupByCategory(List<Transaction> transactions) {
    final Map<String, double> grouped = {};
    for (var t in transactions) {
      grouped[t.category] = (grouped[t.category] ?? 0) + t.amount;
    }
    return grouped;
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = _groupByCategory(_transactions);
    final totalSpent = _transactions.fold(0.0, (sum, tx) => sum + tx.amount);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, totalSpent),
              const SizedBox(height: 16),
              WalletCard(
                balance: _walletBalance,
                onHistory: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TransactionHistoryScreen(
                        initialTransactions: _transactions,
                        budget: userBudget,
                      ),
                    ),
                  );
                },
                onTransaction: (tx) async {
                  setState(() {
                    _transactions.add(tx);
                  });
                  await _saveTransactions();
                  // Deduct transaction amount from wallet and update persistent storage
                  final newBalance = _walletBalance - tx.amount;
                  await StockMarketService().updateWalletBalance(newBalance);
                  await _loadWalletBalance();
                },
              ),
              const SizedBox(height: 16),
              _buildXPAndStreakRow(userXP, streak, userBudget, totalSpent),
              const SizedBox(height: 16),
              _buildTransactionsCard(context, totalSpent, userBudget),
              const SizedBox(height: 24),
              Text(
                'Recent Transactions',
                style: context.savoraText.headlineMedium?.copyWith(
                  color: context.savoraColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              if (_transactions.isEmpty)
                Center(
                  child: Text(
                    'No transactions to show.',
                    style: context.savoraText.bodyMedium?.copyWith(
                      color: context.savoraColors.onSurface.withOpacity(0.7),
                    ),
                  ),
                )
              else
                ListView.builder(
                  itemCount: _transactions.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final tx = _transactions[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: Icon(Icons.attach_money,
                            color: SavoraColors.primary),
                        title: Text(
                          tx.category,
                          style: context.savoraText.titleMedium,
                        ),
                        subtitle: Text(
                          '${tx.date.day}/${tx.date.month}/${tx.date.year}',
                          style: context.savoraText.bodySmall,
                        ),
                        trailing: Text(
                          '₹${tx.amount.toStringAsFixed(2)}',
                          style: context.savoraText.titleMedium?.copyWith(
                            color: SavoraColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 24),
              Text(
                'Spending Breakdown',
                style: context.savoraText.headlineMedium?.copyWith(
                  color: context.savoraColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              if (_transactions.isNotEmpty) ...[
                SizedBox(height: 200, child: SpendingPieChart(data: data)),
                const SizedBox(height: 24),
                SizedBox(height: 200, child: SpendingBarChart(data: data)),
              ],
              const SizedBox(height: 24),
              const Text(
                'Sentiment Analysis',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (_transactions.isNotEmpty)
                SentimentDashboardWidget(
                  transactions: _transactions,
                  monthlyBudget: userBudget,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double totalSpent) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: widget.profileImagePath != null
              ? FileImage(File(widget.profileImagePath!))
              : null,
          child: widget.profileImagePath == null
              ? Icon(Icons.person, size: 20, color: SavoraColors.primary)
              : null,
        ),
        const SizedBox(width: 10),
        Text(
          widget.userName,
          style: context.savoraText.headlineSmall?.copyWith(
            color: context.savoraColors.onSurface,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: Icon(Icons.edit, color: SavoraColors.primary),
          tooltip: 'Set Budget',
          onPressed: () => _showSetBudgetDialog(context),
        ),
      ],
    );
  }

  Widget _buildTransactionsCard(
    BuildContext context,
    double spent,
    double budget,
  ) {
    return GestureDetector(
      onTap: () async {
        final updatedList = await Navigator.push<List<Transaction>>(
          context,
          MaterialPageRoute(
            builder: (_) => TransactionHistoryScreen(
              initialTransactions: _transactions,
              budget: userBudget,
            ),
          ),
        );

        if (updatedList != null) {
          setState(() {
            _transactions = updatedList;
          });
          await _saveTransactions();
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  SavoraColors.primary.withOpacity(0.1),
                  SavoraColors.primary.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transactions',
                        style: context.savoraText.headlineSmall?.copyWith(
                          color: SavoraColors.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Spent: ₹${spent.toStringAsFixed(2)}',
                        style: context.savoraText.bodyMedium,
                      ),
                      const SizedBox(height: 6),
                      TextButton.icon(
                        onPressed: () => _showSetBudgetDialog(context),
                        icon: Icon(Icons.settings, color: SavoraColors.primary),
                        label: Text(
                          'Set Budget',
                          style: TextStyle(color: SavoraColors.primary),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 18, color: SavoraColors.primary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildXPAndStreakRow(int xp, int streak, double budget, double spent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _infoTile('XP', xp.toString(), Icons.bolt, SavoraColors.xpColor),
        _infoTile('Streak', '${streak}d', Icons.local_fire_department,
            SavoraColors.streakColor),
        _infoTile(
          'Budget Left',
          '₹${(budget - spent).toStringAsFixed(0)}',
          Icons.track_changes,
          SavoraColors.success,
        ),
      ],
    );
  }

  Widget _infoTile(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  void _showSetBudgetDialog(BuildContext context) {
    _budgetController.text = userBudget.toStringAsFixed(0);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Set Monthly Budget'),
        content: TextField(
          controller: _budgetController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Enter new budget (₹)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final value = double.tryParse(_budgetController.text);
              if (value != null) {
                setState(() => userBudget = value);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
