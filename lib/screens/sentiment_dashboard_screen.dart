import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction_model.dart';
import '../services/transaction_sentiment_service.dart';
import '../widgets/sentiment_analysis_widget.dart';

class SentimentDashboardScreen extends StatefulWidget {
  final List<Transaction> transactions;
  final double monthlyBudget;

  const SentimentDashboardScreen({
    super.key,
    required this.transactions,
    required this.monthlyBudget,
  });

  @override
  State<SentimentDashboardScreen> createState() => _SentimentDashboardScreenState();
}

class _SentimentDashboardScreenState extends State<SentimentDashboardScreen> {
  late Map<TransactionSentiment, double> spendingSummary;
  late List<String> overallInsights;

  @override
  void initState() {
    super.initState();
    _calculateAnalytics();
  }

  void _calculateAnalytics() {
    spendingSummary = TransactionSentimentService.getSpendingSummary(widget.transactions);
    overallInsights = TransactionSentimentService.getOverallInsights(
      widget.transactions,
      widget.monthlyBudget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spending Insights'),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall insights card
            _buildOverallInsightsCard(theme),
            const SizedBox(height: 16),
            
            // Sentiment distribution chart
            _buildSentimentChart(theme),
            const SizedBox(height: 16),
            
            // Sentiment breakdown
            _buildSentimentBreakdown(theme),
            const SizedBox(height: 16),
            
            // Recent analyzed transactions
            _buildRecentTransactions(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallInsightsCard(ThemeData theme) {
    final totalSpent = spendingSummary.values.fold(0.0, (sum, amount) => sum + amount);
    final budgetUsed = (totalSpent / widget.monthlyBudget * 100).round();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.insights,
                  color: theme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Monthly Overview',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Budget usage indicator
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Budget Usage',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: totalSpent / widget.monthlyBudget,
                        backgroundColor: theme.dividerColor.withOpacity(0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          budgetUsed > 90 ? Colors.red : 
                          budgetUsed > 70 ? Colors.orange : Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${totalSpent.toStringAsFixed(2)} of \$${widget.monthlyBudget.toStringAsFixed(2)} ($budgetUsed%)',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            if (overallInsights.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              ...overallInsights.map((insight) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Colors.amber.shade600,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        insight,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSentimentChart(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spending by Sentiment',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _getPieChartSections(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSentimentBreakdown(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Breakdown',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...TransactionSentiment.values.map((sentiment) {
              final amount = spendingSummary[sentiment] ?? 0;
              if (amount == 0) return const SizedBox.shrink();
              
              final sentimentData = _getSentimentData(sentiment);
              final totalSpent = spendingSummary.values.fold(0.0, (sum, amt) => sum + amt);
              final percentage = totalSpent > 0 ? (amount / totalSpent * 100).round() : 0;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: sentimentData['color'],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _sentimentToString(sentiment),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '\$${amount.toStringAsFixed(2)} ($percentage%)',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: totalSpent > 0 ? amount / totalSpent : 0,
                            backgroundColor: theme.dividerColor.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(sentimentData['color']),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).where((widget) => widget != const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(ThemeData theme) {
    final recentTransactions = widget.transactions
        .where((t) => t.analysis != null)
        .take(5)
        .toList();
    
    if (recentTransactions.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 48,
                color: theme.primaryColor.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No analyzed transactions yet',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Make some transactions to see sentiment analysis',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Recent Analyzed Transactions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...recentTransactions.map((transaction) => SentimentAnalysisWidget(
          analysis: transaction.analysis!,
          transaction: transaction,
        )),
      ],
    );
  }

  List<PieChartSectionData> _getPieChartSections() {
    final totalSpent = spendingSummary.values.fold(0.0, (sum, amount) => sum + amount);
    if (totalSpent == 0) return [];
    
    return TransactionSentiment.values.map((sentiment) {
      final amount = spendingSummary[sentiment] ?? 0;
      if (amount == 0) return null;
      
      final sentimentData = _getSentimentData(sentiment);
      final percentage = (amount / totalSpent * 100);
      
      return PieChartSectionData(
        color: sentimentData['color'],
        value: amount,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).where((section) => section != null).cast<PieChartSectionData>().toList();
  }

  Map<String, dynamic> _getSentimentData(TransactionSentiment sentiment) {
    switch (sentiment) {
      case TransactionSentiment.smart:
        return {'color': Colors.green};
      case TransactionSentiment.planned:
        return {'color': Colors.blue};
      case TransactionSentiment.necessary:
        return {'color': Colors.teal};
      case TransactionSentiment.strategic:
        return {'color': Colors.indigo};
      case TransactionSentiment.emotional:
        return {'color': Colors.orange};
      case TransactionSentiment.impulsive:
        return {'color': Colors.red};
      case TransactionSentiment.wasteful:
        return {'color': Colors.deepOrange};
      case TransactionSentiment.regrettable:
        return {'color': Colors.red.shade800};
    }
  }

  String _sentimentToString(TransactionSentiment sentiment) {
    switch (sentiment) {
      case TransactionSentiment.smart:
        return 'Smart Purchases';
      case TransactionSentiment.planned:
        return 'Planned Expenses';
      case TransactionSentiment.necessary:
        return 'Necessary Items';
      case TransactionSentiment.strategic:
        return 'Strategic Spending';
      case TransactionSentiment.emotional:
        return 'Emotional Purchases';
      case TransactionSentiment.impulsive:
        return 'Impulsive Buying';
      case TransactionSentiment.wasteful:
        return 'Wasteful Spending';
      case TransactionSentiment.regrettable:
        return 'Regrettable Purchases';
    }
  }
}
