// Stock Market Simulation Models for Savora

class Stock {
  final String symbol;
  final String name;
  final String sector;
  final double currentPrice;
  final double previousClose;
  final double volume;
  final double marketCap;
  final double peRatio;
  final String exchange;
  final DateTime lastUpdated;

  Stock({
    required this.symbol,
    required this.name,
    required this.sector,
    required this.currentPrice,
    required this.previousClose,
    required this.volume,
    required this.marketCap,
    required this.peRatio,
    required this.exchange,
    required this.lastUpdated,
  });

  double get change => currentPrice - previousClose;
  double get changePercent => (change / previousClose) * 100;
  bool get isPositive => change >= 0;

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'name': name,
    'sector': sector,
    'currentPrice': currentPrice,
    'previousClose': previousClose,
    'volume': volume,
    'marketCap': marketCap,
    'peRatio': peRatio,
    'exchange': exchange,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
    symbol: json['symbol'],
    name: json['name'],
    sector: json['sector'],
    currentPrice: json['currentPrice'],
    previousClose: json['previousClose'],
    volume: json['volume'],
    marketCap: json['marketCap'],
    peRatio: json['peRatio'],
    exchange: json['exchange'],
    lastUpdated: DateTime.parse(json['lastUpdated']),
  );
}

class Portfolio {
  final String id;
  final String name;
  final double totalValue;
  final double availableCash;
  final double todayChange;
  final double totalChange;
  final List<Holding> holdings;
  final DateTime lastUpdated;

  Portfolio({
    required this.id,
    required this.name,
    required this.totalValue,
    required this.availableCash,
    required this.todayChange,
    required this.totalChange,
    required this.holdings,
    required this.lastUpdated,
  });

  double get totalInvested => totalValue - availableCash;
  double get todayChangePercent => totalInvested > 0 ? (todayChange / totalInvested) * 100 : 0;
  double get totalChangePercent => totalInvested > 0 ? (totalChange / totalInvested) * 100 : 0;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'totalValue': totalValue,
    'availableCash': availableCash,
    'todayChange': todayChange,
    'totalChange': totalChange,
    'holdings': holdings.map((h) => h.toJson()).toList(),
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory Portfolio.fromJson(Map<String, dynamic> json) => Portfolio(
    id: json['id'],
    name: json['name'],
    totalValue: json['totalValue'],
    availableCash: json['availableCash'],
    todayChange: json['todayChange'],
    totalChange: json['totalChange'],
    holdings: (json['holdings'] as List).map((h) => Holding.fromJson(h)).toList(),
    lastUpdated: DateTime.parse(json['lastUpdated']),
  );
}

class Holding {
  final String symbol;
  final String name;
  final int quantity;
  final double averagePrice;
  final double currentPrice;
  final double investedAmount;
  final double currentValue;
  final DateTime purchaseDate;

  Holding({
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.averagePrice,
    required this.currentPrice,
    required this.investedAmount,
    required this.currentValue,
    required this.purchaseDate,
  });

  double get totalGainLoss => currentValue - investedAmount;
  double get gainLossPercent => (totalGainLoss / investedAmount) * 100;
  bool get isProfit => totalGainLoss >= 0;

  Map<String, dynamic> toJson() => {
    'symbol': symbol,
    'name': name,
    'quantity': quantity,
    'averagePrice': averagePrice,
    'currentPrice': currentPrice,
    'investedAmount': investedAmount,
    'currentValue': currentValue,
    'purchaseDate': purchaseDate.toIso8601String(),
  };

  factory Holding.fromJson(Map<String, dynamic> json) => Holding(
    symbol: json['symbol'],
    name: json['name'],
    quantity: json['quantity'],
    averagePrice: json['averagePrice'],
    currentPrice: json['currentPrice'],
    investedAmount: json['investedAmount'],
    currentValue: json['currentValue'],
    purchaseDate: DateTime.parse(json['purchaseDate']),
  );
}

class Transaction {
  final String id;
  final String symbol;
  final String type; // 'BUY' or 'SELL'
  final int quantity;
  final double price;
  final double amount;
  final double charges;
  final DateTime timestamp;
  final String status;

  Transaction({
    required this.id,
    required this.symbol,
    required this.type,
    required this.quantity,
    required this.price,
    required this.amount,
    required this.charges,
    required this.timestamp,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'symbol': symbol,
    'type': type,
    'quantity': quantity,
    'price': price,
    'amount': amount,
    'charges': charges,
    'timestamp': timestamp.toIso8601String(),
    'status': status,
  };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'],
    symbol: json['symbol'],
    type: json['type'],
    quantity: json['quantity'],
    price: json['price'],
    amount: json['amount'],
    charges: json['charges'],
    timestamp: DateTime.parse(json['timestamp']),
    status: json['status'],
  );
}

class MarketNews {
  final String id;
  final String title;
  final String summary;
  final String impact; // 'POSITIVE', 'NEGATIVE', 'NEUTRAL'
  final List<String> affectedSymbols;
  final DateTime publishedAt;
  final String source;

  MarketNews({
    required this.id,
    required this.title,
    required this.summary,
    required this.impact,
    required this.affectedSymbols,
    required this.publishedAt,
    required this.source,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'summary': summary,
    'impact': impact,
    'affectedSymbols': affectedSymbols,
    'publishedAt': publishedAt.toIso8601String(),
    'source': source,
  };

  factory MarketNews.fromJson(Map<String, dynamic> json) => MarketNews(
    id: json['id'],
    title: json['title'],
    summary: json['summary'],
    impact: json['impact'],
    affectedSymbols: List<String>.from(json['affectedSymbols']),
    publishedAt: DateTime.parse(json['publishedAt']),
    source: json['source'],
  );
}

// Popular Indian stocks for simulation
class IndianStocks {
  static final List<Stock> popularStocks = [
    // Technology
    Stock(
      symbol: 'TCS',
      name: 'Tata Consultancy Services',
      sector: 'Technology',
      currentPrice: 3245.50,
      previousClose: 3200.00,
      volume: 1245000,
      marketCap: 1180000000000,
      peRatio: 25.4,
      exchange: 'NSE',
      lastUpdated: DateTime.now(),
    ),
    Stock(
      symbol: 'INFY',
      name: 'Infosys Limited',
      sector: 'Technology',
      currentPrice: 1456.75,
      previousClose: 1440.00,
      volume: 2100000,
      marketCap: 610000000000,
      peRatio: 23.1,
      exchange: 'NSE',
      lastUpdated: DateTime.now(),
    ),
    // Banking
    Stock(
      symbol: 'HDFCBANK',
      name: 'HDFC Bank Limited',
      sector: 'Banking',
      currentPrice: 1598.30,
      previousClose: 1585.20,
      volume: 3200000,
      marketCap: 880000000000,
      peRatio: 18.5,
      exchange: 'NSE',
      lastUpdated: DateTime.now(),
    ),
    Stock(
      symbol: 'ICICIBANK',
      name: 'ICICI Bank Limited',
      sector: 'Banking',
      currentPrice: 945.60,
      previousClose: 938.45,
      volume: 4100000,
      marketCap: 660000000000,
      peRatio: 16.2,
      exchange: 'NSE',
      lastUpdated: DateTime.now(),
    ),
    // Consumer
    Stock(
      symbol: 'RELIANCE',
      name: 'Reliance Industries',
      sector: 'Energy',
      currentPrice: 2456.80,
      previousClose: 2430.50,
      volume: 1800000,
      marketCap: 1650000000000,
      peRatio: 22.8,
      exchange: 'NSE',
      lastUpdated: DateTime.now(),
    ),
    // Pharma
    Stock(
      symbol: 'SUNPHARMA',
      name: 'Sun Pharmaceutical',
      sector: 'Pharmaceuticals',
      currentPrice: 1089.45,
      previousClose: 1075.20,
      volume: 890000,
      marketCap: 260000000000,
      peRatio: 19.6,
      exchange: 'NSE',
      lastUpdated: DateTime.now(),
    ),
    // Auto
    Stock(
      symbol: 'MARUTI',
      name: 'Maruti Suzuki India',
      sector: 'Automotive',
      currentPrice: 10245.30,
      previousClose: 10180.50,
      volume: 560000,
      marketCap: 310000000000,
      peRatio: 21.4,
      exchange: 'NSE',
      lastUpdated: DateTime.now(),
    ),
    // New-age stocks
    Stock(
      symbol: 'ZOMATO',
      name: 'Zomato Limited',
      sector: 'Technology',
      currentPrice: 89.75,
      previousClose: 87.20,
      volume: 5600000,
      marketCap: 78000000000,
      peRatio: 45.2,
      exchange: 'NSE',
      lastUpdated: DateTime.now(),
    ),
  ];
}
