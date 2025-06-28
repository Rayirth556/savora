import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/stock_model.dart';
import '../services/stock_market_service.dart';
import '../theme/savora_theme.dart';

class StockTradingScreen extends StatefulWidget {
  final Stock stock;

  const StockTradingScreen({
    super.key,
    required this.stock,
  });

  @override
  State<StockTradingScreen> createState() => _StockTradingScreenState();
}

class _StockTradingScreenState extends State<StockTradingScreen>
    with TickerProviderStateMixin {
  final StockMarketService _stockService = StockMarketService();
  final TextEditingController _quantityController = TextEditingController();
  
  bool _isBuying = true;
  int _quantity = 1;
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _quantityController.text = _quantity.toString();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  double get _totalAmount {
    final baseAmount = widget.stock.currentPrice * _quantity;
    final charges = baseAmount * 0.001; // 0.1% brokerage
    return baseAmount + charges;
  }

  bool get _canAfford {
    final portfolio = _stockService.userPortfolio;
    if (portfolio == null) return false;
    return _isBuying ? portfolio.availableCash >= _totalAmount : _hasEnoughShares;
  }

  bool get _hasEnoughShares {
    final portfolio = _stockService.userPortfolio;
    if (portfolio == null) return false;
    final holding = portfolio.holdings
        .where((h) => h.symbol == widget.stock.symbol)
        .firstOrNull;
    return holding != null && holding.quantity >= _quantity;
  }

  Future<void> _executeTrade() async {
    setState(() => _isLoading = true);
    
    bool success;
    if (_isBuying) {
      success = await _stockService.buyStock(widget.stock.symbol, _quantity);
    } else {
      success = await _stockService.sellStock(widget.stock.symbol, _quantity);
    }

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_isBuying ? 'Bought' : 'Sold'} $_quantity shares of ${widget.stock.symbol}',
            ),
            backgroundColor: SavoraColors.success,
          ),
        );
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isBuying ? 'Insufficient funds' : 'Insufficient shares',
            ),
            backgroundColor: SavoraColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final portfolio = _stockService.userPortfolio;
    final holding = portfolio?.holdings
        .where((h) => h.symbol == widget.stock.symbol)
        .firstOrNull;

    return Scaffold(
      backgroundColor: context.savoraColors.background,
      appBar: AppBar(
        title: Text(
          '${widget.stock.symbol} - ${widget.stock.name}',
          style: context.savoraText.titleLarge?.copyWith(
            color: context.savoraColors.onSurface,
          ),
        ),
        backgroundColor: context.savoraColors.surface,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'BUY'),
            Tab(text: 'SELL'),
          ],
          indicatorColor: SavoraColors.primary,
          labelColor: SavoraColors.primary,
          unselectedLabelColor: context.savoraColors.onSurface.withOpacity(0.6),
          onTap: (index) {
            setState(() {
              _isBuying = index == 0;
            });
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTradeForm(true, portfolio, holding),
          _buildTradeForm(false, portfolio, holding),
        ],
      ),
    );
  }

  Widget _buildTradeForm(bool isBuy, Portfolio? portfolio, Holding? holding) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Stock info card
          Card(
            color: context.savoraColors.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.stock.symbol,
                        style: context.savoraText.titleLarge?.copyWith(
                          color: context.savoraColors.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.stock.changePercent >= 0
                              ? SavoraColors.success
                              : SavoraColors.error,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${widget.stock.changePercent >= 0 ? '+' : ''}${widget.stock.changePercent.toStringAsFixed(2)}%',
                          style: context.savoraText.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Price',
                        style: context.savoraText.bodyMedium?.copyWith(
                          color: context.savoraColors.onSurface.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '₹${widget.stock.currentPrice.toStringAsFixed(2)}',
                        style: context.savoraText.titleMedium?.copyWith(
                          color: context.savoraColors.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Portfolio info
          if (portfolio != null) ...[
            Card(
              color: context.savoraColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Portfolio Info',
                      style: context.savoraText.titleMedium?.copyWith(
                        color: context.savoraColors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Available Cash',
                          style: context.savoraText.bodyMedium?.copyWith(
                            color: context.savoraColors.onSurface.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          '₹${portfolio.availableCash.toStringAsFixed(2)}',
                          style: context.savoraText.bodyMedium?.copyWith(
                            color: context.savoraColors.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (holding != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Current Holdings',
                            style: context.savoraText.bodyMedium?.copyWith(
                              color: context.savoraColors.onSurface.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            '${holding.quantity} shares',
                            style: context.savoraText.bodyMedium?.copyWith(
                              color: context.savoraColors.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Quantity input
          Card(
            color: context.savoraColors.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quantity',
                    style: context.savoraText.titleMedium?.copyWith(
                      color: context.savoraColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _quantity > 1
                            ? () {
                                setState(() {
                                  _quantity--;
                                  _quantityController.text = _quantity.toString();
                                });
                              }
                            : null,
                        icon: const Icon(Icons.remove),
                        style: IconButton.styleFrom(
                          backgroundColor: SavoraColors.primary.withOpacity(0.1),
                          foregroundColor: SavoraColors.primary,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _quantityController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: SavoraColors.primary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: SavoraColors.primary, width: 2),
                            ),
                          ),
                          onChanged: (value) {
                            final qty = int.tryParse(value) ?? 1;
                            setState(() {
                              _quantity = qty > 0 ? qty : 1;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _quantity++;
                            _quantityController.text = _quantity.toString();
                          });
                        },
                        icon: const Icon(Icons.add),
                        style: IconButton.styleFrom(
                          backgroundColor: SavoraColors.primary.withOpacity(0.1),
                          foregroundColor: SavoraColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Order summary
          Card(
            color: context.savoraColors.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Summary',
                    style: context.savoraText.titleMedium?.copyWith(
                      color: context.savoraColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price per share',
                        style: context.savoraText.bodyMedium?.copyWith(
                          color: context.savoraColors.onSurface.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '₹${widget.stock.currentPrice.toStringAsFixed(2)}',
                        style: context.savoraText.bodyMedium?.copyWith(
                          color: context.savoraColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity',
                        style: context.savoraText.bodyMedium?.copyWith(
                          color: context.savoraColors.onSurface.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '$_quantity shares',
                        style: context.savoraText.bodyMedium?.copyWith(
                          color: context.savoraColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sub-total',
                        style: context.savoraText.bodyMedium?.copyWith(
                          color: context.savoraColors.onSurface.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '₹${(widget.stock.currentPrice * _quantity).toStringAsFixed(2)}',
                        style: context.savoraText.bodyMedium?.copyWith(
                          color: context.savoraColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Brokerage (0.1%)',
                        style: context.savoraText.bodyMedium?.copyWith(
                          color: context.savoraColors.onSurface.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '₹${(widget.stock.currentPrice * _quantity * 0.001).toStringAsFixed(2)}',
                        style: context.savoraText.bodyMedium?.copyWith(
                          color: context.savoraColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: context.savoraText.titleMedium?.copyWith(
                          color: context.savoraColors.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹${_totalAmount.toStringAsFixed(2)}',
                        style: context.savoraText.titleMedium?.copyWith(
                          color: SavoraColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Trade button
          ElevatedButton(
            onPressed: _canAfford && !_isLoading ? _executeTrade : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isBuy ? SavoraColors.success : SavoraColors.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    isBuy ? 'BUY SHARES' : 'SELL SHARES',
                    style: context.savoraText.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),

          if (!_canAfford) ...[
            const SizedBox(height: 8),
            Text(
              isBuy
                  ? 'Insufficient funds to complete this transaction'
                  : 'Insufficient shares to complete this transaction',
              style: context.savoraText.bodySmall?.copyWith(
                color: SavoraColors.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
