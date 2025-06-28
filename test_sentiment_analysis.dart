import 'lib/models/transaction_model.dart';
import 'lib/services/transaction_sentiment_service.dart';

void main() {
  // Test sentiment analysis
  print('=== Savora Sentiment Analysis Demo ===\n');
  
  // Sample transaction history
  final history = [
    Transaction(
      amount: 50.0,
      category: 'Food',
      date: DateTime.now().subtract(Duration(days: 5)),
      description: 'Grocery shopping',
    ),
    Transaction(
      amount: 25.0,
      category: 'Food',
      date: DateTime.now().subtract(Duration(days: 3)),
      description: 'Coffee',
    ),
    Transaction(
      amount: 200.0,
      category: 'Shopping',
      date: DateTime.now().subtract(Duration(days: 2)),
      description: 'New clothes',
    ),
    Transaction(
      amount: 80.0,
      category: 'Transport',
      date: DateTime.now().subtract(Duration(days: 1)),
      description: 'Gas',
    ),
  ];
  
  final budget = 1000.0;
  
  print('Transaction History:');
  for (var tx in history) {
    print('- \$${tx.amount} on ${tx.category} (${tx.description})');
  }
  print('\nMonthly Budget: \$${budget.toStringAsFixed(2)}\n');
  
  // Test different transaction scenarios
  final testCases = [
    {
      'amount': 500.0,
      'category': 'Shopping',
      'description': 'Limited time sale on electronics',
    },
    {
      'amount': 30.0,
      'category': 'Food',
      'description': 'Weekly groceries',
    },
    {
      'amount': 1000.0,
      'category': 'Education',
      'description': 'Online course investment',
    },
    {
      'amount': 15.0,
      'category': 'Food',
      'description': 'Coffee and snacks',
    },
  ];
  
  print('=== SENTIMENT ANALYSIS PREDICTIONS ===\n');
  
  for (int i = 0; i < testCases.length; i++) {
    final testCase = testCases[i];
    print('Test Case ${i + 1}: \$${testCase['amount']} - ${testCase['category']}');
    print('Description: ${testCase['description']}\n');
    
    final analysis = TransactionSentimentService.predictTransactionSentiment(
      amount: testCase['amount'] as double,
      category: testCase['category'] as String,
      transactionHistory: history,
      budget: budget,
      description: testCase['description'] as String?,
    );
    
    print('🎯 PREDICTION: ${analysis.sentiment.name.toUpperCase()}');
    print('🔮 Confidence: ${(analysis.confidenceScore * 100).toStringAsFixed(1)}%');
    print('💭 Reason: ${analysis.reason}');
    print('📊 Pattern: ${analysis.pattern.name}');
    
    if (analysis.insights.isNotEmpty) {
      print('💡 Insights:');
      for (var insight in analysis.insights) {
        print('   • $insight');
      }
    }
    
    // Get suggestions
    final suggestions = TransactionSentimentService.getTransactionSuggestions(
      amount: testCase['amount'] as double,
      category: testCase['category'] as String,
      transactionHistory: history,
      budget: budget,
      description: testCase['description'] as String?,
    );
    
    if (suggestions.isNotEmpty) {
      print('🚀 Suggestions:');
      for (var suggestion in suggestions.take(3)) {
        print('   • $suggestion');
      }
    }
    
    print('\n${'=' * 50}\n');
  }
  
  // Overall insights
  print('=== OVERALL SPENDING INSIGHTS ===\n');
  final recommendations = TransactionSentimentService.getSpendingRecommendations(history, budget);
  
  for (var recommendation in recommendations) {
    print('💰 $recommendation');
  }
  
  print('\n=== END DEMO ===');
}
