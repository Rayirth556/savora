import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_sentiment_service.dart';

class SentimentDashboardWidget extends StatelessWidget {
  final List<Transaction> transactions;
  final double monthlyBudget;

  const SentimentDashboardWidget({
    super.key,
    required this.transactions,
    required this.monthlyBudget,
  });

  @override
  Widget build(BuildContext context) {
    final summary =
        TransactionSentimentService.getSpendingSummary(transactions);
    final insights = TransactionSentimentService.getOverallInsights(
        transactions, monthlyBudget);
    final totalSpent = summary.values.fold(0.0, (sum, amount) => sum + amount);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spending Analysis',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Spending breakdown by sentiment
            _buildSpendingBreakdown(context, summary, totalSpent),
            const SizedBox(height: 16),

            // Insights
            if (insights.isNotEmpty) ...[
              Text(
                'Insights',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              ...insights.map((insight) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb,
                            size: 16, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            insight,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],

            const SizedBox(height: 16),

            // Overall sentiment score
            _buildOverallScore(context, summary, totalSpent),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingBreakdown(BuildContext context,
      Map<TransactionSentiment, double> summary, double totalSpent) {
    return Column(
      children: summary.entries.where((entry) => entry.value > 0).map((entry) {
        final percentage =
            totalSpent > 0 ? (entry.value / totalSpent * 100) : 0;
        final color = TransactionSentimentService.getSentimentColor(entry.key);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _sentimentToDisplayName(entry.key),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Text(
                '₹${entry.value.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOverallScore(BuildContext context,
      Map<TransactionSentiment, double> summary, double totalSpent) {
    // Calculate overall financial health score
    double score = 0;
    final smartSpending = summary[TransactionSentiment.smart] ?? 0;
    final necessarySpending = summary[TransactionSentiment.necessary] ?? 0;
    final strategicSpending = summary[TransactionSentiment.strategic] ?? 0;
    final plannedSpending = summary[TransactionSentiment.planned] ?? 0;
    final impulsiveSpending = summary[TransactionSentiment.impulsive] ?? 0;
    final wastefulSpending = summary[TransactionSentiment.wasteful] ?? 0;

    if (totalSpent > 0) {
      score = ((smartSpending +
                  necessarySpending +
                  strategicSpending +
                  plannedSpending * 0.8) /
              totalSpent) *
          100;
      score =
          score - ((impulsiveSpending + wastefulSpending) / totalSpent) * 50;
      score = score.clamp(0, 100);
    }

    Color scoreColor;
    String scoreName;
    IconData scoreIcon;

    if (score >= 80) {
      scoreColor = Colors.green;
      scoreName = 'Excellent';
      scoreIcon = Icons.sentiment_very_satisfied;
    } else if (score >= 60) {
      scoreColor = Colors.lightGreen;
      scoreName = 'Good';
      scoreIcon = Icons.sentiment_satisfied;
    } else if (score >= 40) {
      scoreColor = Colors.orange;
      scoreName = 'Fair';
      scoreIcon = Icons.sentiment_neutral;
    } else {
      scoreColor = Colors.red;
      scoreName = 'Needs Improvement';
      scoreIcon = Icons.sentiment_dissatisfied;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scoreColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scoreColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(scoreIcon, color: scoreColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Financial Health Score',
                  style: TextStyle(
                    color: scoreColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '$scoreName (${score.toStringAsFixed(1)}/100)',
                  style: TextStyle(
                    color: scoreColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _sentimentToDisplayName(TransactionSentiment sentiment) {
    switch (sentiment) {
      case TransactionSentiment.smart:
        return 'Smart Spending';
      case TransactionSentiment.necessary:
        return 'Necessary Expenses';
      case TransactionSentiment.strategic:
        return 'Strategic Investments';
      case TransactionSentiment.planned:
        return 'Planned Purchases';
      case TransactionSentiment.impulsive:
        return 'Impulsive Buying';
      case TransactionSentiment.emotional:
        return 'Emotional Spending';
      case TransactionSentiment.wasteful:
        return 'Wasteful Expenses';
      case TransactionSentiment.regrettable:
        return 'Regrettable Purchases';
    }
  }
}
