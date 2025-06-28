enum TransactionSentiment {
  smart,
  impulsive,
  necessary,
  wasteful,
  strategic,
  emotional,
  planned,
  regrettable
}

enum SpendingPattern {
  frequent,
  occasional,
  rare,
  seasonal,
  emergency
}

class TransactionAnalysis {
  final TransactionSentiment sentiment;
  final SpendingPattern pattern;
  final double confidenceScore;
  final String reason;
  final List<String> insights;

  TransactionAnalysis({
    required this.sentiment,
    required this.pattern,
    required this.confidenceScore,
    required this.reason,
    required this.insights,
  });

  Map<String, dynamic> toJson() => {
    'sentiment': sentiment.name,
    'pattern': pattern.name,
    'confidenceScore': confidenceScore,
    'reason': reason,
    'insights': insights,
  };

  factory TransactionAnalysis.fromJson(Map<String, dynamic> json) => TransactionAnalysis(
    sentiment: TransactionSentiment.values.firstWhere(
      (e) => e.name == json['sentiment'],
      orElse: () => TransactionSentiment.necessary,
    ),
    pattern: SpendingPattern.values.firstWhere(
      (e) => e.name == json['pattern'],
      orElse: () => SpendingPattern.occasional,
    ),
    confidenceScore: json['confidenceScore']?.toDouble() ?? 0.0,
    reason: json['reason'] ?? '',
    insights: List<String>.from(json['insights'] ?? []),
  );
}

class Transaction {
  final double amount;
  final String category;
  final DateTime date;
  final String? description;
  final TransactionAnalysis? analysis;

  Transaction({
    required this.amount,
    required this.category,
    required this.date,
    this.description,
    this.analysis,
  });

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'category': category,
    'date': date.toIso8601String(),
    'description': description,
    'analysis': analysis?.toJson(),
  };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    amount: json['amount'],
    category: json['category'],
    date: DateTime.parse(json['date']),
    description: json['description'],
    analysis: json['analysis'] != null 
        ? TransactionAnalysis.fromJson(json['analysis'])
        : null,
  );

  Transaction copyWith({
    double? amount,
    String? category,
    DateTime? date,
    String? description,
    TransactionAnalysis? analysis,
  }) {
    return Transaction(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      analysis: analysis ?? this.analysis,
    );
  }
}
