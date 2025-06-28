// Stock Market Dashboard Screen for Savora
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/stock_model.dart';
import '../services/stock_market_service.dart';
import '../theme/savora_theme.dart';
import '../widgets/funds_transfer_dialog.dart';
import 'stock_trading_screen.dart';
import 'portfolio_details_screen.dart';

class StockMarketDashboardScreen extends StatefulWidget {
  const StockMarketDashboardScreen({super.key});

  @override
  State<StockMarketDashboardScreen> createState() => _StockMarketDashboardScreenState();
}

class _StockMarketDashboardScreenState extends State<StockMarketDashboardScreen>
    with TickerProviderStateMixin {
  final StockMarketService _stockService = StockMarketService();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  List<Stock> _stocks = [];
  Portfolio? _portfolio;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _initializeStockMarket();
  }

  Future<void> _initializeStockMarket() async {
    await _stockService.initialize();
    
    // Create default portfolio if none exists
    if (_stockService.userPortfolio == null) {
      await _stockService.createPortfolio('My Portfolio', 100000); // ₹1 Lakh virtual money
    }
    
    setState(() {
      _stocks = _stockService.allStocks;
      _portfolio = _stockService.userPortfolio;
      _isLoading = false;
    });
    
    _animationController.forward();
    
    // Listen to stock updates
    _stockService.stockUpdates.listen((updatedStocks) {
      if (mounted) {
        setState(() {
          _stocks = updatedStocks;
          _portfolio = _stockService.userPortfolio;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: SavoraColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: SavoraColors.primary),
              const SizedBox(height: 16),
              Text(
                'Initializing Stock Market...',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: SavoraColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: SavoraColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildPortfolioOverview(),
                const SizedBox(height: 24),
                _buildQuickActions(),
                const SizedBox(height: 24),
                _buildMarketOverview(),
                const SizedBox(height: 24),
                _buildTopMovers(),
                const SizedBox(height: 24),
                _buildRecentNews(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: SavoraColors.primaryGradient),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.trending_up,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stock Market',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: SavoraColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _stockService.isMarketOpen ? SavoraColors.success : SavoraColors.danger,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _stockService.isMarketOpen ? 'Market Open' : 'Market Closed',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: SavoraColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PortfolioDetailsScreen(),
              ),
            );
          },
          icon: Icon(Icons.newspaper, color: SavoraColors.primary),
        ),
      ],
    );
  }

  Widget _buildPortfolioOverview() {
    if (_portfolio == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: SavoraColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: SavoraColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Portfolio Value',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PortfolioDetailsScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'View Details',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '₹${_portfolio!.totalValue.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                _portfolio!.todayChange >= 0 ? Icons.trending_up : Icons.trending_down,
                color: _portfolio!.todayChange >= 0 ? SavoraColors.success : SavoraColors.danger,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${_portfolio!.todayChange >= 0 ? '+' : ''}₹${_portfolio!.todayChange.toStringAsFixed(2)} (${_portfolio!.todayChangePercent.toStringAsFixed(2)}%)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPortfolioStat(
                  'Invested',
                  '₹${_portfolio!.totalInvested.toStringAsFixed(0)}',
                ),
              ),
              Expanded(
                child: _buildPortfolioStat(
                  'Available Cash',
                  '₹${_portfolio!.availableCash.toStringAsFixed(0)}',
                ),
              ),
              Expanded(
                child: _buildPortfolioStat(
                  'P&L',
                  '${_portfolio!.totalChange >= 0 ? '+' : ''}₹${_portfolio!.totalChange.toStringAsFixed(0)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Trade Stocks',
                Icons.candlestick_chart,
                SavoraColors.primary,
                () {
                  _showStockSelection();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Portfolio',
                Icons.pie_chart,
                SavoraColors.secondary,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PortfolioDetailsScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Market Info',
                Icons.analytics,
                SavoraColors.accent,
                () {
                  _showMarketInfo();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Add Funds',
                Icons.account_balance_wallet,
                SavoraColors.success,
                () async {
                  final walletBalance = await _stockService.getWalletBalance();
                  if (mounted) {
                    _showFundsTransfer('wallet_to_portfolio', walletBalance);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Withdraw',
                Icons.money,
                SavoraColors.warning,
                () {
                  if (_portfolio != null) {
                    _showFundsTransfer('portfolio_to_wallet', _portfolio!.availableCash);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(), // Empty space for alignment
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SavoraColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: SavoraColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SavoraColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Market Overview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: SavoraColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMarketStat('Gainers', _getGainersCount(), SavoraColors.success),
              ),
              Expanded(
                child: _buildMarketStat('Losers', _getLosersCount(), SavoraColors.danger),
              ),
              Expanded(
                child: _buildMarketStat('Unchanged', _getUnchangedCount(), SavoraColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarketStat(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: SavoraColors.textSecondary,
          ),
        ),
      ],
    );
  }

  int _getGainersCount() => _stocks.where((s) => s.change > 0).length;
  int _getLosersCount() => _stocks.where((s) => s.change < 0).length;
  int _getUnchangedCount() => _stocks.where((s) => s.change == 0).length;

  Widget _buildTopMovers() {
    final topGainers = _stocks.where((s) => s.change > 0).take(3).toList();
    final topLosers = _stocks.where((s) => s.change < 0).take(3).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SavoraColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Movers',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: SavoraColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Gainers',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: SavoraColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...topGainers.map((stock) => _buildMoverItem(stock, true)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Losers',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: SavoraColors.danger,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...topLosers.map((stock) => _buildMoverItem(stock, false)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoverItem(Stock stock, bool isGainer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              stock.symbol,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: SavoraColors.textPrimary,
              ),
            ),
          ),
          Text(
            '${isGainer ? '+' : ''}${stock.changePercent.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isGainer ? SavoraColors.success : SavoraColors.danger,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentNews() {
    final recentNews = _stockService.marketNews.take(3).toList();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SavoraColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Market News',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: SavoraColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showMarketInfo();
                },
                child: Text(
                  'View All',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SavoraColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recentNews.map((news) => _buildNewsItem(news)),
        ],
      ),
    );
  }

  Widget _buildNewsItem(MarketNews news) {
    Color impactColor;
    IconData impactIcon;
    
    switch (news.impact) {
      case 'POSITIVE':
        impactColor = SavoraColors.success;
        impactIcon = Icons.trending_up;
        break;
      case 'NEGATIVE':
        impactColor = SavoraColors.danger;
        impactIcon = Icons.trending_down;
        break;
      default:
        impactColor = SavoraColors.textSecondary;
        impactIcon = Icons.trending_flat;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: impactColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(impactIcon, color: impactColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: SavoraColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  news.summary,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: SavoraColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showStockSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.savoraColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.savoraColors.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Select Stock to Trade',
              style: context.savoraText.titleLarge?.copyWith(
                color: context.savoraColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _stocks.length,
                itemBuilder: (context, index) {
                  final stock = _stocks[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: SavoraColors.primary.withOpacity(0.1),
                      child: Text(
                        stock.symbol.substring(0, 2),
                        style: context.savoraText.bodySmall?.copyWith(
                          color: SavoraColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      stock.symbol,
                      style: context.savoraText.titleMedium?.copyWith(
                        color: context.savoraColors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      stock.name,
                      style: context.savoraText.bodySmall?.copyWith(
                        color: context.savoraColors.onSurface.withOpacity(0.7),
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${stock.currentPrice.toStringAsFixed(2)}',
                          style: context.savoraText.bodyMedium?.copyWith(
                            color: context.savoraColors.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: stock.changePercent >= 0 ? SavoraColors.success : SavoraColors.error,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${stock.changePercent >= 0 ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%',
                            style: context.savoraText.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StockTradingScreen(stock: stock),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMarketInfo() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.savoraColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.savoraColors.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Market Information',
              style: context.savoraText.titleLarge?.copyWith(
                color: context.savoraColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildMarketInfoItem('Market Status', _stockService.isMarketOpen ? 'Open' : 'Closed'),
            _buildMarketInfoItem('Trading Hours', '9:15 AM - 3:30 PM'),
            _buildMarketInfoItem('Brokerage', '0.1% per transaction'),
            _buildMarketInfoItem('Settlement', 'T+2 (Demo Mode)'),
            const SizedBox(height: 16),
            Text(
              'Market News',
              style: context.savoraText.titleMedium?.copyWith(
                color: context.savoraColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _stockService.marketNews.length,
                itemBuilder: (context, index) {
                  final news = _stockService.marketNews[index];
                  return Card(
                    color: context.savoraColors.background,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            news.title,
                            style: context.savoraText.bodyMedium?.copyWith(
                              color: context.savoraColors.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            news.summary,
                            style: context.savoraText.bodySmall?.copyWith(
                              color: context.savoraColors.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFundsTransfer(String transferType, double maxAmount) {
    showDialog(
      context: context,
      builder: (context) => FundsTransferDialog(
        transferType: transferType,
        maxAmount: maxAmount,
        onTransferComplete: () {
          setState(() {
            _portfolio = _stockService.userPortfolio;
          });
        },
      ),
    );
  }

  Widget _buildMarketInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.savoraText.bodyMedium?.copyWith(
              color: context.savoraColors.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: context.savoraText.bodyMedium?.copyWith(
              color: context.savoraColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
