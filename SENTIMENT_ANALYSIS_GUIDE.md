# Sentiment Analysis Integration Guide

## Overview
This implementation provides comprehensive sentiment analysis for financial transactions, categorizing them as:

- **Smart**: Well-planned, beneficial purchases
- **Planned**: Scheduled expenses with good timing  
- **Necessary**: Essential purchases (bills, healthcare, etc.)
- **Strategic**: Long-term value investments
- **Emotional**: Emotion-driven purchases
- **Impulsive**: Spur-of-the-moment buying decisions
- **Wasteful**: Potentially unnecessary expenses
- **Regrettable**: High likelihood of buyer's remorse

## Key Features

### 1. Multi-Factor Analysis
- **Amount Factor**: Relative to monthly budget
- **Category Factor**: Inherent category scoring
- **Frequency Factor**: Based on similar past transactions
- **Timing Factor**: Late night, weekend, payday patterns
- **Description Factor**: Keyword analysis for emotional triggers

### 2. Spending Patterns
- **Frequent**: Multiple times per week
- **Occasional**: Few times per month  
- **Rare**: Infrequent purchases
- **Seasonal**: Periodic based on calendar
- **Emergency**: Urgent, unplanned expenses

### 3. Actionable Insights
- Category-specific recommendations
- Frequency-based suggestions
- Budget optimization tips
- Behavioral pattern alerts

## Usage Examples

### Basic Transaction Analysis
```dart
// Create a transaction
final transaction = Transaction(
  amount: 150.0,
  category: 'Shopping',
  date: DateTime.now(),
  description: 'Flash sale item, limited time offer',
);

// Analyze sentiment
final analysis = TransactionSentimentService.analyzeTransaction(
  transaction,
  transactionHistory, // List of past transactions
  monthlyBudget,     // User's monthly budget
);

// Result: Likely "Impulsive" due to keywords and amount
print(analysis.sentiment); // TransactionSentiment.impulsive
print(analysis.reason);    // "Shows signs of impulsive decision-making"
print(analysis.insights);  // ["Try waiting 24 hours before similar purchases"]
```

### Dashboard Integration
```dart
// Get spending summary
final summary = TransactionSentimentService.getSpendingSummary(transactions);
// Returns: Map<TransactionSentiment, double>

// Get overall insights
final insights = TransactionSentimentService.getOverallInsights(
  transactions, 
  monthlyBudget
);
// Returns: List<String> with actionable advice
```

## Integration Steps

### 1. Update your existing transaction creation:
```dart
// Before
final transaction = Transaction(
  amount: amount,
  category: category,
  date: DateTime.now(),
);

// After
final transaction = Transaction(
  amount: amount,
  category: category,
  date: DateTime.now(),
  description: description, // Add description field
);

// Analyze and attach sentiment
final analysis = TransactionSentimentService.analyzeTransaction(
  transaction,
  existingTransactions,
  monthlyBudget,
);

final analyzedTransaction = transaction.copyWith(analysis: analysis);
```

### 2. Display sentiment in transaction lists:
```dart
// In your transaction list widget
if (transaction.analysis != null) {
  SentimentAnalysisWidget(
    analysis: transaction.analysis!,
    transaction: transaction,
  )
}
```

### 3. Add sentiment dashboard:
```dart
// Navigate to sentiment dashboard
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SentimentDashboardScreen(
      transactions: allTransactions,
      monthlyBudget: userBudget,
    ),
  ),
);
```

## Customization

### Adding New Categories
Update the `_categoryWeights` map in `TransactionSentimentService`:
```dart
static const Map<String, double> _categoryWeights = {
  'YourNewCategory': 0.7, // 0.1 = likely impulsive, 0.9 = likely smart
  // ... existing categories
};
```

### Adding Sentiment Keywords
Update the keyword maps:
```dart
static const Map<String, List<String>> _impulsiveKeywords = {
  'your_trigger': ['keyword1', 'keyword2', 'keyword3'],
  // ... existing keywords
};
```

### Custom Insights
Extend the `_generateInsights` method with your business logic:
```dart
// Category-specific insights
if (transaction.category == 'YourCategory') {
  // Add custom logic
  insights.add('Your custom insight');
}
```

## Best Practices

1. **Regular Analysis**: Analyze transactions immediately after creation for real-time feedback
2. **Historical Context**: Always pass transaction history for accurate pattern detection  
3. **Budget Awareness**: Keep monthly budget updated for relevant amount factor calculations
4. **User Education**: Show users what triggers different sentiment categories
5. **Privacy**: All analysis is performed locally - no data sent to external services

## Future Enhancements

- Machine learning model training on user behavior
- Seasonal spending pattern recognition
- Goal-based sentiment scoring
- Social spending comparison (anonymized)
- Integration with financial planning tools

## Example Implementation in Home Screen

```dart
// In your home screen where transactions are managed
class HomeScreen extends StatefulWidget {
  // ... existing code

  void _addTransaction() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionsScreen(
          budget: monthlyBudget,
          transactionHistory: transactions, // Pass existing transactions
        ),
      ),
    );

    if (result != null && result is Transaction) {
      setState(() {
        transactions.add(result); // Transaction already has analysis attached
      });
      
      // Show sentiment feedback to user
      if (result.analysis != null) {
        _showSentimentFeedback(result.analysis!);
      }
    }
  }

  void _showSentimentFeedback(TransactionAnalysis analysis) {
    final sentiment = analysis.sentiment;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaction classified as: ${sentiment.name}'),
        backgroundColor: _getSentimentColor(sentiment),
      ),
    );
  }
}
```

This integration provides immediate value to users by:
- Making them aware of spending patterns
- Providing actionable insights
- Helping identify emotional triggers
- Supporting better financial decision-making
