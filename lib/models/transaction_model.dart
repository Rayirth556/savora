class Transaction {
  final double amount;
  final String category;
  final DateTime date;

  Transaction({
    required this.amount,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'category': category,
    'date': date.toIso8601String(),
  };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    amount: json['amount'],
    category: json['category'],
    date: DateTime.parse(json['date']),
  );
}
