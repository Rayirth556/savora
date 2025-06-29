import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class SentimentAnalysisWidget extends StatelessWidget {
  final TransactionAnalysis analysis;
  final Transaction transaction;

  const SentimentAnalysisWidget({
    super.key,
    required this.analysis,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with sentiment and confidence
            Row(
              children: [
                _buildSentimentChip(theme),
                const Spacer(),
                _buildConfidenceIndicator(theme),
              ],
            ),
            const SizedBox(height: 12),

            // Transaction details
            _buildTransactionDetails(theme),
            const SizedBox(height: 12),

            // Reason
            _buildReason(theme),
            const SizedBox(height: 16),

            // Insights
            if (analysis.insights.isNotEmpty) ...[
              _buildInsights(theme),
              const SizedBox(height: 12),
            ],

            // Pattern indicator
            _buildPatternIndicator(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSentimentChip(ThemeData theme) {
    final sentimentData = _getSentimentData(analysis.sentiment);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: sentimentData['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: sentimentData['color']),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            sentimentData['icon'],
            size: 16,
            color: sentimentData['color'],
          ),
          const SizedBox(width: 6),
          Text(
            _sentimentToString(analysis.sentiment),
            style: TextStyle(
              color: sentimentData['color'],
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceIndicator(ThemeData theme) {
    final confidence = (analysis.confidenceScore * 100).round();
    final color = _getConfidenceColor(analysis.confidenceScore);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$confidence% confident',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTransactionDetails(ThemeData theme) {
    return Row(
      children: [
        Icon(
          _getCategoryIcon(transaction.category),
          color: theme.primaryColor.withOpacity(0.7),
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '₹${transaction.amount.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${transaction.category} • ${_formatDate(transaction.date)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReason(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.psychology,
            color: theme.primaryColor.withOpacity(0.7),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              analysis.reason,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsights(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: Colors.amber.shade600,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              'Insights',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...analysis.insights.map((insight) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade600,
                      shape: BoxShape.circle,
                    ),
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
    );
  }

  Widget _buildPatternIndicator(ThemeData theme) {
    final patternData = _getPatternData(analysis.pattern);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: patternData['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            patternData['icon'],
            size: 14,
            color: patternData['color'],
          ),
          const SizedBox(width: 4),
          Text(
            _patternToString(analysis.pattern),
            style: TextStyle(
              color: patternData['color'],
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getSentimentData(TransactionSentiment sentiment) {
    switch (sentiment) {
      case TransactionSentiment.smart:
        return {'color': Colors.green, 'icon': Icons.check_circle};
      case TransactionSentiment.planned:
        return {'color': Colors.blue, 'icon': Icons.schedule};
      case TransactionSentiment.necessary:
        return {'color': Colors.teal, 'icon': Icons.medical_services};
      case TransactionSentiment.strategic:
        return {'color': Colors.indigo, 'icon': Icons.trending_up};
      case TransactionSentiment.emotional:
        return {'color': Colors.orange, 'icon': Icons.favorite};
      case TransactionSentiment.impulsive:
        return {'color': Colors.red, 'icon': Icons.flash_on};
      case TransactionSentiment.wasteful:
        return {'color': Colors.deepOrange, 'icon': Icons.warning};
      case TransactionSentiment.regrettable:
        return {'color': Colors.red.shade800, 'icon': Icons.error};
    }
  }

  Map<String, dynamic> _getPatternData(SpendingPattern pattern) {
    switch (pattern) {
      case SpendingPattern.frequent:
        return {'color': Colors.red, 'icon': Icons.repeat};
      case SpendingPattern.occasional:
        return {'color': Colors.blue, 'icon': Icons.access_time};
      case SpendingPattern.rare:
        return {'color': Colors.green, 'icon': Icons.star};
      case SpendingPattern.seasonal:
        return {'color': Colors.purple, 'icon': Icons.calendar_today};
      case SpendingPattern.emergency:
        return {'color': Colors.red.shade700, 'icon': Icons.emergency};
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.blue;
    if (confidence >= 0.4) return Colors.orange;
    return Colors.red;
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
      case 'groceries':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'bills':
      case 'utilities':
        return Icons.receipt;
      case 'healthcare':
        return Icons.medical_services;
      case 'education':
        return Icons.school;
      case 'investment':
        return Icons.trending_up;
      default:
        return Icons.payment;
    }
  }

  String _sentimentToString(TransactionSentiment sentiment) {
    switch (sentiment) {
      case TransactionSentiment.smart:
        return 'Smart';
      case TransactionSentiment.planned:
        return 'Planned';
      case TransactionSentiment.necessary:
        return 'Necessary';
      case TransactionSentiment.strategic:
        return 'Strategic';
      case TransactionSentiment.emotional:
        return 'Emotional';
      case TransactionSentiment.impulsive:
        return 'Impulsive';
      case TransactionSentiment.wasteful:
        return 'Wasteful';
      case TransactionSentiment.regrettable:
        return 'Regrettable';
    }
  }

  String _patternToString(SpendingPattern pattern) {
    switch (pattern) {
      case SpendingPattern.frequent:
        return 'Frequent';
      case SpendingPattern.occasional:
        return 'Occasional';
      case SpendingPattern.rare:
        return 'Rare';
      case SpendingPattern.seasonal:
        return 'Seasonal';
      case SpendingPattern.emergency:
        return 'Emergency';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '${difference} days ago';
    if (difference < 30) return '${(difference / 7).round()} weeks ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}
