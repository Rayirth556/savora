import '../models/transaction_model.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class TransactionSentimentService {
  // Constants for analysis
  static const double _highSpendingMultiplier = 2.0;
  static const int _frequentTransactionDays = 3;
  static const double _budgetWarningThreshold = 0.8;

  /// Predict transaction sentiment BEFORE processing payment
  /// Shows user what kind of transaction they're about to make
  static TransactionAnalysis predictTransactionSentiment({
    required double amount,
    required String category,
    required List<Transaction> transactionHistory,
    required double budget,
    String? description,
  }) {
    // Create a temporary transaction for analysis
    final tempTransaction = Transaction(
      amount: amount,
      category: category,
      date: DateTime.now(),
      description: description,
    );

    return _performSentimentAnalysis(tempTransaction, transactionHistory, budget);
  }

  /// Analyzes a transaction and predicts its sentiment/nature
  static TransactionAnalysis analyzeTransaction(
    Transaction transaction,
    List<Transaction> transactionHistory,
    double budget,
  ) {
    return _performSentimentAnalysis(transaction, transactionHistory, budget);
  }

  static TransactionAnalysis _performSentimentAnalysis(
    Transaction transaction,
    List<Transaction> history,
    double budget,
  ) {
    final insights = <String>[];
    double confidenceScore = 0.7; // Base confidence

    // Category-specific analysis
    final categoryHistory = history.where((t) => t.category == transaction.category).toList();
    final avgCategorySpending = categoryHistory.isNotEmpty
        ? categoryHistory.map((t) => t.amount).reduce((a, b) => a + b) / categoryHistory.length
        : 0.0;

    // Time-based analysis
    final recentTransactions = history.where((t) => 
        DateTime.now().difference(t.date).inDays <= _frequentTransactionDays).toList();
    
    final currentMonthSpending = history.where((t) => 
        t.date.month == DateTime.now().month && 
        t.date.year == DateTime.now().year).fold(0.0, (sum, t) => sum + t.amount);

    // Amount analysis
    final totalSpending = history.fold(0.0, (sum, t) => sum + t.amount);
    final avgTransactionAmount = history.isNotEmpty ? totalSpending / history.length : 0.0;

    // Determine sentiment
    TransactionSentiment sentiment;
    SpendingPattern pattern;
    String reason;

    // Pattern analysis
    if (categoryHistory.length > 10) {
      pattern = SpendingPattern.frequent;
      insights.add("You frequently spend in ${transaction.category}");
    } else if (categoryHistory.length > 3) {
      pattern = SpendingPattern.occasional;
    } else if (categoryHistory.isEmpty) {
      pattern = SpendingPattern.rare;
      insights.add("This is a new spending category for you");
      confidenceScore += 0.1;
    } else {
      pattern = SpendingPattern.occasional;
    }

    // Sentiment analysis based on multiple factors
    if (transaction.amount > avgCategorySpending * _highSpendingMultiplier && 
        avgCategorySpending > 0) {
      sentiment = TransactionSentiment.impulsive;
      reason = "Amount is significantly higher than your usual ${transaction.category} spending";
      insights.add("This is ${((transaction.amount / avgCategorySpending - 1) * 100).toStringAsFixed(0)}% more than your average");
      confidenceScore += 0.2;
    } else if (recentTransactions.length > 5) {
      sentiment = TransactionSentiment.impulsive;
      reason = "You've been spending frequently in recent days";
      insights.add("${recentTransactions.length} transactions in the last ${_frequentTransactionDays} days");
      confidenceScore += 0.15;
    } else if (currentMonthSpending + transaction.amount > budget * _budgetWarningThreshold) {
      if (transaction.category.toLowerCase().contains('food') || 
          transaction.category.toLowerCase().contains('grocery') ||
          transaction.category.toLowerCase().contains('bill')) {
        sentiment = TransactionSentiment.necessary;
        reason = "Essential spending, but approaching budget limit";
        insights.add("Budget usage: ${((currentMonthSpending + transaction.amount) / budget * 100).toStringAsFixed(1)}%");
      } else {
        sentiment = TransactionSentiment.wasteful;
        reason = "Non-essential spending while approaching budget limit";
        insights.add("This will push you to ${((currentMonthSpending + transaction.amount) / budget * 100).toStringAsFixed(1)}% of your budget");
        confidenceScore += 0.25;
      }
    } else if (transaction.amount < avgTransactionAmount * 0.5 && avgTransactionAmount > 0) {
      sentiment = TransactionSentiment.smart;
      reason = "Below your average spending - good financial control";
      insights.add("This is a smaller purchase compared to your usual spending");
      confidenceScore += 0.1;
    } else if (_isEssentialCategory(transaction.category)) {
      sentiment = TransactionSentiment.necessary;
      reason = "Essential category spending";
      insights.add("${transaction.category} is typically a necessary expense");
    } else if (_isInvestmentCategory(transaction.category)) {
      sentiment = TransactionSentiment.strategic;
      reason = "Investment in your future or well-being";
      insights.add("This category typically provides long-term value");
      confidenceScore += 0.15;
    } else {
      sentiment = TransactionSentiment.planned;
      reason = "Regular discretionary spending within normal patterns";
    }

    // Add budget insights
    final budgetRemaining = budget - currentMonthSpending - transaction.amount;
    if (budgetRemaining > 0) {
      insights.add("Budget remaining after this: \$${budgetRemaining.toStringAsFixed(2)}");
    } else {
      insights.add("⚠️ This will exceed your budget by \$${budgetRemaining.abs().toStringAsFixed(2)}");
      if (sentiment == TransactionSentiment.smart || sentiment == TransactionSentiment.planned) {
        sentiment = TransactionSentiment.wasteful;
        reason = "Exceeds monthly budget";
      }
    }

    // Add spending velocity insight
    if (history.isNotEmpty) {
      final daysWithTransactions = history.map((t) => 
          "${t.date.year}-${t.date.month}-${t.date.day}").toSet().length;
      final avgDailySpending = totalSpending / max(daysWithTransactions, 1);
      insights.add("Your average daily spending: \$${avgDailySpending.toStringAsFixed(2)}");
    }

    return TransactionAnalysis(
      sentiment: sentiment,
      pattern: pattern,
      confidenceScore: min(confidenceScore, 1.0),
      reason: reason,
      insights: insights,
    );
  }

  static bool _isEssentialCategory(String category) {
    final essentialCategories = [
      'food', 'grocery', 'groceries', 'bills', 'utilities', 'rent', 
      'mortgage', 'insurance', 'medical', 'healthcare', 'transport',
      'gas', 'fuel', 'medicine', 'pharmacy'
    ];
    return essentialCategories.any((essential) => 
        category.toLowerCase().contains(essential));
  }

  static bool _isInvestmentCategory(String category) {
    final investmentCategories = [
      'education', 'books', 'course', 'training', 'gym', 'fitness',
      'investment', 'savings', 'retirement', 'stocks', 'crypto'
    ];
    return investmentCategories.any((investment) => 
        category.toLowerCase().contains(investment));
  }

  /// Get sentiment color for UI display
  static Color getSentimentColor(TransactionSentiment sentiment) {
    switch (sentiment) {
      case TransactionSentiment.smart:
        return Colors.green;
      case TransactionSentiment.necessary:
        return Colors.blue;
      case TransactionSentiment.strategic:
        return Colors.purple;
      case TransactionSentiment.planned:
        return Colors.blueGrey;
      case TransactionSentiment.impulsive:
        return Colors.orange;
      case TransactionSentiment.emotional:
        return Colors.pink;
      case TransactionSentiment.wasteful:
        return Colors.red;
      case TransactionSentiment.regrettable:
        return Colors.brown;
    }
  }

  /// Get sentiment description for user
  static String getSentimentDescription(TransactionSentiment sentiment) {
    switch (sentiment) {
      case TransactionSentiment.smart:
        return "Smart spending - good financial decision";
      case TransactionSentiment.necessary:
        return "Necessary expense - essential for daily life";
      case TransactionSentiment.strategic:
        return "Strategic investment - long-term value";
      case TransactionSentiment.planned:
        return "Planned purchase - within normal patterns";
      case TransactionSentiment.impulsive:
        return "Impulsive buying - consider if you really need this";
      case TransactionSentiment.emotional:
        return "Emotional spending - spending due to feelings";
      case TransactionSentiment.wasteful:
        return "Potentially wasteful - reconsider this purchase";
      case TransactionSentiment.regrettable:
        return "Likely to regret - avoid this purchase";
    }
  }

  /// Gets spending summary for a time period
  static Map<TransactionSentiment, double> getSpendingSummary(List<Transaction> transactions) {
    final summary = <TransactionSentiment, double>{};
    
    for (final sentiment in TransactionSentiment.values) {
      summary[sentiment] = transactions
          .where((t) => t.analysis?.sentiment == sentiment)
          .fold(0.0, (sum, t) => sum + t.amount);
    }
    
    return summary;
  }

  /// Gets insights for overall spending behavior
  static List<String> getOverallInsights(List<Transaction> transactions, double monthlyBudget) {
    final insights = <String>[];
    final summary = getSpendingSummary(transactions);
    final totalSpent = summary.values.fold(0.0, (sum, amount) => sum + amount);
    
    if (totalSpent > monthlyBudget * 0.9) {
      insights.add('You\'re approaching your monthly budget limit');
    }
    
    final impulsiveSpending = summary[TransactionSentiment.impulsive] ?? 0;
    if (impulsiveSpending > totalSpent * 0.2) {
      insights.add('Consider reducing impulsive purchases to improve financial health');
    }
    
    final smartSpending = summary[TransactionSentiment.smart] ?? 0;
    if (smartSpending > totalSpent * 0.6) {
      insights.add('Excellent job! Most of your spending appears to be well-planned');
    }
    
    return insights;
  }

  /// Get real-time suggestions based on current transaction input
  static List<String> getTransactionSuggestions({
    required double amount,
    required String category,
    required List<Transaction> transactionHistory,
    required double budget,
    String? description,
  }) {
    final suggestions = <String>[];
    
    // Analyze the potential transaction
    final analysis = predictTransactionSentiment(
      amount: amount,
      category: category,
      transactionHistory: transactionHistory,
      budget: budget,
      description: description,
    );
    
    // Budget-based suggestions
    final currentMonthSpending = transactionHistory.where((t) => 
        t.date.month == DateTime.now().month && 
        t.date.year == DateTime.now().year).fold(0.0, (sum, t) => sum + t.amount);
    
    final remainingBudget = budget - currentMonthSpending;
    final budgetUsageAfter = (currentMonthSpending + amount) / budget;
    
    if (budgetUsageAfter > 0.9) {
      suggestions.add("⚠️ This will use ${(budgetUsageAfter * 100).toStringAsFixed(1)}% of your monthly budget");
    } else if (budgetUsageAfter > 0.7) {
      suggestions.add("📊 You'll have \$${(remainingBudget - amount).toStringAsFixed(2)} left this month");
    }
    
    // Category-based suggestions
    final categoryHistory = transactionHistory.where((t) => t.category == category).toList();
    if (categoryHistory.isNotEmpty) {
      final avgCategorySpending = categoryHistory.map((t) => t.amount).reduce((a, b) => a + b) / categoryHistory.length;
      
      if (amount > avgCategorySpending * 1.5) {
        suggestions.add("📈 This is ${((amount / avgCategorySpending - 1) * 100).toStringAsFixed(0)}% more than your usual $category spending");
        suggestions.add("💡 Consider if this purchase is necessary or if you can find a better deal");
      } else if (amount < avgCategorySpending * 0.7) {
        suggestions.add("👍 Great! This is below your average $category spending");
      }
    }
    
    // Time-based suggestions
    final recentTransactions = transactionHistory.where((t) => 
        DateTime.now().difference(t.date).inDays <= 3).toList();
    
    if (recentTransactions.length > 5) {
      suggestions.add("🛒 You've made ${recentTransactions.length} transactions in the last 3 days");
      suggestions.add("💭 Consider taking a break from spending to avoid impulse purchases");
    }
    
    // Sentiment-based suggestions
    switch (analysis.sentiment) {
      case TransactionSentiment.impulsive:
        suggestions.add("⏳ Try the 24-hour rule: wait a day before making this purchase");
        suggestions.add("🤔 Ask yourself: Do I really need this right now?");
        break;
      case TransactionSentiment.smart:
        suggestions.add("✅ This looks like a smart financial decision!");
        break;
      case TransactionSentiment.wasteful:
        suggestions.add("💸 Consider if this expense aligns with your financial goals");
        suggestions.add("🎯 Could this money be better used elsewhere?");
        break;
      case TransactionSentiment.necessary:
        suggestions.add("✓ This appears to be a necessary expense");
        break;
      case TransactionSentiment.strategic:
        suggestions.add("🎯 Good choice! This investment may benefit you long-term");
        break;
      default:
        break;
    }
    
    return suggestions;
  }

  /// Get spending recommendations based on transaction history
  static List<String> getSpendingRecommendations(List<Transaction> transactions, double monthlyBudget) {
    final recommendations = <String>[];
    final summary = getSpendingSummary(transactions);
    final totalSpent = summary.values.fold(0.0, (sum, amount) => sum + amount);
    
    if (totalSpent == 0) {
      recommendations.add("Start tracking your expenses to get personalized insights!");
      return recommendations;
    }
    
    // Budget recommendations
    if (totalSpent > monthlyBudget) {
      recommendations.add("🚨 You've exceeded your monthly budget by \$${(totalSpent - monthlyBudget).toStringAsFixed(2)}");
      recommendations.add("📉 Consider reducing discretionary spending next month");
    } else if (totalSpent > monthlyBudget * 0.9) {
      recommendations.add("⚠️ You're using ${((totalSpent / monthlyBudget) * 100).toStringAsFixed(1)}% of your budget");
      recommendations.add("🎯 Focus on essential purchases for the rest of the month");
    }
    
    // Category recommendations
    final impulsiveSpending = summary[TransactionSentiment.impulsive] ?? 0;
    final wastefulSpending = summary[TransactionSentiment.wasteful] ?? 0;
    final smartSpending = summary[TransactionSentiment.smart] ?? 0;
    
    if (impulsiveSpending > totalSpent * 0.2) {
      recommendations.add("🛑 ${((impulsiveSpending / totalSpent) * 100).toStringAsFixed(1)}% of your spending appears impulsive");
      recommendations.add("💡 Try making shopping lists and sticking to them");
    }
    
    if (smartSpending > totalSpent * 0.6) {
      recommendations.add("🌟 Excellent! ${((smartSpending / totalSpent) * 100).toStringAsFixed(1)}% of your spending is smart");
      recommendations.add("👏 Keep up the good financial habits!");
    }
    
    if (wastefulSpending > totalSpent * 0.15) {
      recommendations.add("💸 Consider reducing wasteful expenses (\$${wastefulSpending.toStringAsFixed(2)})");
      recommendations.add("🎯 Redirect this money towards savings or investments");
    }
    
    return recommendations;
  }
}
