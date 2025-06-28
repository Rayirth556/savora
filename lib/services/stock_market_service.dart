// Stock Market Simulation Service for Savora
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/stock_model.dart';

class StockMarketService {
  static final StockMarketService _instance = StockMarketService._internal();
  factory StockMarketService() => _instance;
  StockMarketService._internal();

  final Random _random = Random();
  Timer? _marketTimer;
  final List<Stock> _stocks = List.from(IndianStocks.popularStocks);
  final StreamController<List<Stock>> _stockUpdateController = StreamController<List<Stock>>.broadcast();
  final StreamController<MarketNews> _newsController = StreamController<MarketNews>.broadcast();
  
  Portfolio? _userPortfolio;
  final List<Transaction> _transactionHistory = [];
  final List<MarketNews> _marketNews = [];

  // Market status
  bool _isMarketOpen = true;
  DateTime? _marketOpenTime;
  DateTime? _marketCloseTime;

  // Wallet integration
  static const String _walletBalanceKey = 'wallet_balance';
  static const String _portfolioKey = 'stock_portfolio';
  
  Stream<List<Stock>> get stockUpdates => _stockUpdateController.stream;
  Stream<MarketNews> get newsUpdates => _newsController.stream;
  
  List<Stock> get allStocks => _stocks;
  Portfolio? get userPortfolio => _userPortfolio;
  List<Transaction> get transactionHistory => _transactionHistory;
  List<MarketNews> get marketNews => _marketNews;
  bool get isMarketOpen => _isMarketOpen;

  // Wallet integration methods
  Future<double> getWalletBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_walletBalanceKey) ?? 5000.0; // Default balance
  }

  Future<void> updateWalletBalance(double newBalance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_walletBalanceKey, newBalance);
  }

  Future<void> transferToPortfolio(double amount) async {
    final currentWalletBalance = await getWalletBalance();
    if (currentWalletBalance >= amount) {
      await updateWalletBalance(currentWalletBalance - amount);
      if (_userPortfolio != null) {
        _userPortfolio = Portfolio(
          id: _userPortfolio!.id,
          name: _userPortfolio!.name,
          totalValue: _userPortfolio!.totalValue + amount,
          availableCash: _userPortfolio!.availableCash + amount,
          todayChange: _userPortfolio!.todayChange,
          totalChange: _userPortfolio!.totalChange,
          holdings: _userPortfolio!.holdings,
          lastUpdated: DateTime.now(),
        );
        await _saveUserData();
      }
    }
  }

  Future<void> transferToWallet(double amount) async {
    if (_userPortfolio != null && _userPortfolio!.availableCash >= amount) {
      _userPortfolio = Portfolio(
        id: _userPortfolio!.id,
        name: _userPortfolio!.name,
        totalValue: _userPortfolio!.totalValue - amount,
        availableCash: _userPortfolio!.availableCash - amount,
        todayChange: _userPortfolio!.todayChange,
        totalChange: _userPortfolio!.totalChange,
        holdings: _userPortfolio!.holdings,
        lastUpdated: DateTime.now(),
      );
      final currentWalletBalance = await getWalletBalance();
      await updateWalletBalance(currentWalletBalance + amount);
      await _saveUserData();
    }
  }

  Future<void> initialize() async {
    await _loadUserData();
    _initializeMarketHours();
    _startMarketSimulation();
    _generateInitialNews();
  }

  void _initializeMarketHours() {
    final now = DateTime.now();
    _marketOpenTime = DateTime(now.year, now.month, now.day, 9, 15); // 9:15 AM
    _marketCloseTime = DateTime(now.year, now.month, now.day, 15, 30); // 3:30 PM
    
    _isMarketOpen = now.isAfter(_marketOpenTime!) && now.isBefore(_marketCloseTime!);
  }

  void _startMarketSimulation() {
    _marketTimer?.cancel();
    _marketTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_isMarketOpen) {
        _updateStockPrices();
        _generateRandomNews();
      }
    });
  }

  void _updateStockPrices() {
    for (int i = 0; i < _stocks.length; i++) {
      final stock = _stocks[i];
      final volatility = _getStockVolatility(stock.sector);
      final change = _random.nextGaussian() * volatility;
      final newPrice = stock.currentPrice * (1 + change / 100);
      
      _stocks[i] = Stock(
        symbol: stock.symbol,
        name: stock.name,
        sector: stock.sector,
        currentPrice: double.parse(newPrice.toStringAsFixed(2)),
        previousClose: stock.previousClose,
        volume: stock.volume + _random.nextInt(100000),
        marketCap: stock.marketCap,
        peRatio: stock.peRatio,
        exchange: stock.exchange,
        lastUpdated: DateTime.now(),
      );
    }
    
    _stockUpdateController.add(_stocks);
    _updatePortfolioValue();
  }

  double _getStockVolatility(String sector) {
    switch (sector) {
      case 'Technology':
        return 2.5; // Higher volatility
      case 'Banking':
        return 1.8;
      case 'Pharmaceuticals':
        return 2.0;
      case 'Energy':
        return 2.2;
      case 'Automotive':
        return 1.9;
      default:
        return 2.0;
    }
  }

  void _generateRandomNews() {
    if (_random.nextDouble() < 0.1) { // 10% chance every update
      final newsItem = _generateMarketNews();
      _marketNews.insert(0, newsItem);
      if (_marketNews.length > 20) {
        _marketNews.removeLast();
      }
      _newsController.add(newsItem);
    }
  }

  MarketNews _generateMarketNews() {
    final templates = [
      {
        'title': 'Q{quarter} Results: {company} beats estimates',
        'summary': '{company} reported strong quarterly results with revenue growth of {growth}%',
        'impact': 'POSITIVE',
      },
      {
        'title': 'Regulatory concerns for {sector} sector',
        'summary': 'New regulations may impact {sector} companies including {company}',
        'impact': 'NEGATIVE',
      },
      {
        'title': '{company} announces strategic partnership',
        'summary': 'Strategic alliance expected to boost {company} market position',
        'impact': 'POSITIVE',
      },
      {
        'title': 'Market volatility due to global factors',
        'summary': 'Global economic uncertainty affecting Indian markets, {sector} sector most impacted',
        'impact': 'NEUTRAL',
      },
    ];

    final template = templates[_random.nextInt(templates.length)];
    final randomStock = _stocks[_random.nextInt(_stocks.length)];
    
    return MarketNews(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: template['title']!
          .replaceAll('{company}', randomStock.name)
          .replaceAll('{sector}', randomStock.sector)
          .replaceAll('{quarter}', 'Q${_random.nextInt(4) + 1}'),
      summary: template['summary']!
          .replaceAll('{company}', randomStock.name)
          .replaceAll('{sector}', randomStock.sector)
          .replaceAll('{growth}', (10 + _random.nextInt(20)).toString()),
      impact: template['impact']!,
      affectedSymbols: [randomStock.symbol],
      publishedAt: DateTime.now(),
      source: 'Savora Market News',
    );
  }

  void _generateInitialNews() {
    for (int i = 0; i < 5; i++) {
      _marketNews.add(_generateMarketNews());
    }
  }

  Future<Portfolio> createPortfolio(String name, double initialCash) async {
    _userPortfolio = Portfolio(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      totalValue: initialCash,
      availableCash: initialCash,
      todayChange: 0,
      totalChange: 0,
      holdings: [],
      lastUpdated: DateTime.now(),
    );
    
    await _saveUserData();
    return _userPortfolio!;
  }

  Future<bool> buyStock(String symbol, int quantity) async {
    if (_userPortfolio == null) return false;
    
    final stock = _stocks.firstWhere((s) => s.symbol == symbol);
    final totalCost = stock.currentPrice * quantity;
    final charges = totalCost * 0.001; // 0.1% brokerage
    final totalAmount = totalCost + charges;
    
    if (_userPortfolio!.availableCash < totalAmount) {
      return false; // Insufficient funds
    }

    // Create transaction
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      symbol: symbol,
      type: 'BUY',
      quantity: quantity,
      price: stock.currentPrice,
      amount: totalAmount,
      charges: charges,
      timestamp: DateTime.now(),
      status: 'COMPLETED',
    );

    _transactionHistory.insert(0, transaction);

    // Update portfolio
    final existingHolding = _userPortfolio!.holdings
        .where((h) => h.symbol == symbol)
        .firstOrNull;

    final updatedHoldings = List<Holding>.from(_userPortfolio!.holdings);
    
    if (existingHolding != null) {
      // Update existing holding
      final newQuantity = existingHolding.quantity + quantity;
      final newInvestedAmount = existingHolding.investedAmount + totalCost;
      final newAveragePrice = newInvestedAmount / newQuantity;
      
      updatedHoldings.removeWhere((h) => h.symbol == symbol);
      updatedHoldings.add(Holding(
        symbol: symbol,
        name: stock.name,
        quantity: newQuantity,
        averagePrice: newAveragePrice,
        currentPrice: stock.currentPrice,
        investedAmount: newInvestedAmount,
        currentValue: stock.currentPrice * newQuantity,
        purchaseDate: existingHolding.purchaseDate,
      ));
    } else {
      // Create new holding
      updatedHoldings.add(Holding(
        symbol: symbol,
        name: stock.name,
        quantity: quantity,
        averagePrice: stock.currentPrice,
        currentPrice: stock.currentPrice,
        investedAmount: totalCost,
        currentValue: stock.currentPrice * quantity,
        purchaseDate: DateTime.now(),
      ));
    }

    _userPortfolio = Portfolio(
      id: _userPortfolio!.id,
      name: _userPortfolio!.name,
      totalValue: _userPortfolio!.totalValue,
      availableCash: _userPortfolio!.availableCash - totalAmount,
      todayChange: _userPortfolio!.todayChange,
      totalChange: _userPortfolio!.totalChange,
      holdings: updatedHoldings,
      lastUpdated: DateTime.now(),
    );

    await _saveUserData();
    return true;
  }

  Future<bool> sellStock(String symbol, int quantity) async {
    if (_userPortfolio == null) return false;
    
    final holding = _userPortfolio!.holdings
        .where((h) => h.symbol == symbol)
        .firstOrNull;
    
    if (holding == null || holding.quantity < quantity) {
      return false; // Insufficient stocks
    }

    final stock = _stocks.firstWhere((s) => s.symbol == symbol);
    final totalValue = stock.currentPrice * quantity;
    final charges = totalValue * 0.001; // 0.1% brokerage
    final netAmount = totalValue - charges;

    // Create transaction
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      symbol: symbol,
      type: 'SELL',
      quantity: quantity,
      price: stock.currentPrice,
      amount: netAmount,
      charges: charges,
      timestamp: DateTime.now(),
      status: 'COMPLETED',
    );

    _transactionHistory.insert(0, transaction);

    // Update portfolio
    final updatedHoldings = List<Holding>.from(_userPortfolio!.holdings);
    updatedHoldings.removeWhere((h) => h.symbol == symbol);
    
    if (holding.quantity > quantity) {
      // Partial sell - update holding
      final remainingQuantity = holding.quantity - quantity;
      final remainingInvestedAmount = holding.investedAmount * (remainingQuantity / holding.quantity);
      
      updatedHoldings.add(Holding(
        symbol: symbol,
        name: holding.name,
        quantity: remainingQuantity,
        averagePrice: holding.averagePrice,
        currentPrice: stock.currentPrice,
        investedAmount: remainingInvestedAmount,
        currentValue: stock.currentPrice * remainingQuantity,
        purchaseDate: holding.purchaseDate,
      ));
    }

    _userPortfolio = Portfolio(
      id: _userPortfolio!.id,
      name: _userPortfolio!.name,
      totalValue: _userPortfolio!.totalValue,
      availableCash: _userPortfolio!.availableCash + netAmount,
      todayChange: _userPortfolio!.todayChange,
      totalChange: _userPortfolio!.totalChange,
      holdings: updatedHoldings,
      lastUpdated: DateTime.now(),
    );

    await _saveUserData();
    return true;
  }

  void _updatePortfolioValue() {
    if (_userPortfolio == null) return;

    double totalValue = _userPortfolio!.availableCash;
    double todayChange = 0;
    double totalChange = 0;

    final updatedHoldings = _userPortfolio!.holdings.map((holding) {
      final stock = _stocks.firstWhere((s) => s.symbol == holding.symbol);
      final currentValue = stock.currentPrice * holding.quantity;
      final dayChange = (stock.currentPrice - stock.previousClose) * holding.quantity;
      final totalGainLoss = currentValue - holding.investedAmount;

      totalValue += currentValue;
      todayChange += dayChange;
      totalChange += totalGainLoss;

      return Holding(
        symbol: holding.symbol,
        name: holding.name,
        quantity: holding.quantity,
        averagePrice: holding.averagePrice,
        currentPrice: stock.currentPrice,
        investedAmount: holding.investedAmount,
        currentValue: currentValue,
        purchaseDate: holding.purchaseDate,
      );
    }).toList();

    _userPortfolio = Portfolio(
      id: _userPortfolio!.id,
      name: _userPortfolio!.name,
      totalValue: totalValue,
      availableCash: _userPortfolio!.availableCash,
      todayChange: todayChange,
      totalChange: totalChange,
      holdings: updatedHoldings,
      lastUpdated: DateTime.now(),
    );
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (_userPortfolio != null) {
      await prefs.setString('stock_portfolio', jsonEncode(_userPortfolio!.toJson()));
    }
    
    await prefs.setString('stock_transactions', 
        jsonEncode(_transactionHistory.map((t) => t.toJson()).toList()));
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final portfolioData = prefs.getString('stock_portfolio');
    if (portfolioData != null) {
      _userPortfolio = Portfolio.fromJson(jsonDecode(portfolioData));
    }
    
    final transactionsData = prefs.getString('stock_transactions');
    if (transactionsData != null) {
      final transactions = jsonDecode(transactionsData) as List;
      _transactionHistory.clear();
      _transactionHistory.addAll(
        transactions.map((t) => Transaction.fromJson(t)).toList()
      );
    }
  }

  Stock? getStock(String symbol) {
    try {
      return _stocks.firstWhere((s) => s.symbol == symbol);
    } catch (e) {
      return null;
    }
  }

  List<Stock> searchStocks(String query) {
    return _stocks.where((stock) =>
        stock.symbol.toLowerCase().contains(query.toLowerCase()) ||
        stock.name.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  List<Stock> getStocksBySector(String sector) {
    return _stocks.where((stock) => stock.sector == sector).toList();
  }

  List<String> getAllSectors() {
    return _stocks.map((stock) => stock.sector).toSet().toList();
  }

  void dispose() {
    _marketTimer?.cancel();
    _stockUpdateController.close();
    _newsController.close();
  }
}

// Extension for Gaussian random numbers
extension RandomGaussian on Random {
  double nextGaussian() {
    double u1 = nextDouble();
    double u2 = nextDouble();
    return sqrt(-2 * log(u1)) * cos(2 * pi * u2);
  }
}
