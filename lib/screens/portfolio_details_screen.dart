import 'package:flutter/material.dart';
import '../models/stock_model.dart';
import '../services/stock_market_service.dart';
import '../theme/savora_theme.dart';
import 'stock_trading_screen.dart';

class PortfolioDetailsScreen extends StatefulWidget {
  const PortfolioDetailsScreen({super.key});

  @override
  State<PortfolioDetailsScreen> createState() => _PortfolioDetailsScreenState();
}

class _PortfolioDetailsScreenState extends State<PortfolioDetailsScreen>
    with TickerProviderStateMixin {
  final StockMarketService _stockService = StockMarketService();
  late TabController _tabController;
  Portfolio? _portfolio;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPortfolio();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadPortfolio() {
    setState(() {
      _portfolio = _stockService.userPortfolio;
    });
  }

  Future<void> _navigateToTrading(Stock stock) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => StockTradingScreen(stock: stock),
      ),
    );
    
    if (result == true) {
      _loadPortfolio();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.savoraColors.background,
      appBar: AppBar(
        title: Text(
          'Portfolio Details',
          style: context.savoraText.titleLarge?.copyWith(
            color: context.savoraColors.onSurface,
          ),
        ),
        backgroundColor: context.savoraColors.surface,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Holdings'),
            Tab(text: 'Transactions'),
          ],
          indicatorColor: SavoraColors.primary,
          labelColor: SavoraColors.primary,
          unselectedLabelColor: context.savoraColors.onSurface.withOpacity(0.6),
        ),
      ),
      body: _portfolio == null
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildHoldingsTab(),
                _buildTransactionsTab(),
              ],
            ),
    );
  }

  Widget _buildHoldingsTab() {
    if (_portfolio!.holdings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline,
              size: 64,
              color: context.savoraColors.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No Holdings Yet',
              style: context.savoraText.titleMedium?.copyWith(
                color: context.savoraColors.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start investing to see your holdings here',
              style: context.savoraText.bodyMedium?.copyWith(
                color: context.savoraColors.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _portfolio!.holdings.length,
      itemBuilder: (context, index) {
        final holding = _portfolio!.holdings[index];
        final stock = _stockService.allStocks
            .firstWhere((s) => s.symbol == holding.symbol);
        
        final currentValue = stock.currentPrice * holding.quantity;
        final gainLoss = currentValue - holding.investedAmount;
        final gainLossPercent = (gainLoss / holding.investedAmount) * 100;

        return Card(
          color: context.savoraColors.surface,
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => _navigateToTrading(stock),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stock.symbol,
                            style: context.savoraText.titleMedium?.copyWith(
                              color: context.savoraColors.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${holding.quantity} shares',
                            style: context.savoraText.bodySmall?.copyWith(
                              color: context.savoraColors.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${currentValue.toStringAsFixed(2)}',
                            style: context.savoraText.titleMedium?.copyWith(
                              color: context.savoraColors.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: gainLoss >= 0 ? SavoraColors.success : SavoraColors.error,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${gainLoss >= 0 ? '+' : ''}${gainLossPercent.toStringAsFixed(2)}%',
                              style: context.savoraText.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetric(
                          'Current Price',
                          '₹${stock.currentPrice.toStringAsFixed(2)}',
                        ),
                      ),
                      Expanded(
                        child: _buildMetric(
                          'Avg. Price',
                          '₹${holding.averagePrice.toStringAsFixed(2)}',
                        ),
                      ),
                      Expanded(
                        child: _buildMetric(
                          'P&L',
                          '₹${gainLoss.toStringAsFixed(2)}',
                          color: gainLoss >= 0 ? SavoraColors.success : SavoraColors.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionsTab() {
    final transactions = _stockService.transactionHistory;
    
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: context.savoraColors.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No Transactions Yet',
              style: context.savoraText.titleMedium?.copyWith(
                color: context.savoraColors.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your trading history will appear here',
              style: context.savoraText.bodyMedium?.copyWith(
                color: context.savoraColors.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final isBuy = transaction.type == 'BUY';

        return Card(
          color: context.savoraColors.surface,
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isBuy ? SavoraColors.success : SavoraColors.error,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                transaction.type,
                                style: context.savoraText.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              transaction.symbol,
                              style: context.savoraText.titleMedium?.copyWith(
                                color: context.savoraColors.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${transaction.quantity} shares @ ₹${transaction.price.toStringAsFixed(2)}',
                          style: context.savoraText.bodyMedium?.copyWith(
                            color: context.savoraColors.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${transaction.amount.toStringAsFixed(2)}',
                          style: context.savoraText.titleMedium?.copyWith(
                            color: context.savoraColors.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatDate(transaction.timestamp),
                          style: context.savoraText.bodySmall?.copyWith(
                            color: context.savoraColors.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (transaction.charges > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Brokerage: ₹${transaction.charges.toStringAsFixed(2)}',
                    style: context.savoraText.bodySmall?.copyWith(
                      color: context.savoraColors.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetric(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.savoraText.bodySmall?.copyWith(
            color: context.savoraColors.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: context.savoraText.bodyMedium?.copyWith(
            color: color ?? context.savoraColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
