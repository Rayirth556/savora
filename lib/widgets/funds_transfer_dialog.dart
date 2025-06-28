import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/stock_market_service.dart';
import '../theme/savora_theme.dart';

class FundsTransferDialog extends StatefulWidget {
  final String transferType; // 'wallet_to_portfolio' or 'portfolio_to_wallet'
  final double maxAmount;
  final VoidCallback? onTransferComplete;

  const FundsTransferDialog({
    super.key,
    required this.transferType,
    required this.maxAmount,
    this.onTransferComplete,
  });

  @override
  State<FundsTransferDialog> createState() => _FundsTransferDialogState();
}

class _FundsTransferDialogState extends State<FundsTransferDialog> {
  final TextEditingController _amountController = TextEditingController();
  final StockMarketService _stockService = StockMarketService();
  bool _isLoading = false;
  double _amount = 0;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  bool get _isWalletToPortfolio => widget.transferType == 'wallet_to_portfolio';
  String get _sourceLabel => _isWalletToPortfolio ? 'Wallet' : 'Portfolio';
  String get _destinationLabel => _isWalletToPortfolio ? 'Portfolio' : 'Wallet';

  Future<void> _executeTransfer() async {
    if (_amount <= 0 || _amount > widget.maxAmount) return;

    setState(() => _isLoading = true);

    try {
      if (_isWalletToPortfolio) {
        await _stockService.transferToPortfolio(_amount);
      } else {
        await _stockService.transferToWallet(_amount);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Successfully transferred ₹${_amount.toStringAsFixed(2)} to $_destinationLabel',
            ),
            backgroundColor: SavoraColors.success,
          ),
        );
        Navigator.of(context).pop();
        widget.onTransferComplete?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transfer failed: $e'),
            backgroundColor: SavoraColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.savoraColors.surface,
      title: Text(
        'Transfer Funds',
        style: context.savoraText.titleLarge?.copyWith(
          color: context.savoraColors.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transfer from $_sourceLabel to $_destinationLabel',
            style: context.savoraText.bodyMedium?.copyWith(
              color: context.savoraColors.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Available Balance: ₹${widget.maxAmount.toStringAsFixed(2)}',
            style: context.savoraText.bodyMedium?.copyWith(
              color: context.savoraColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: 'Amount',
              prefixText: '₹',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: SavoraColors.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: SavoraColors.primary, width: 2),
              ),
              labelStyle: TextStyle(color: SavoraColors.primary),
            ),
            onChanged: (value) {
              setState(() {
                _amount = double.tryParse(value) ?? 0;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildQuickAmountButton('25%', widget.maxAmount * 0.25),
              const SizedBox(width: 8),
              _buildQuickAmountButton('50%', widget.maxAmount * 0.5),
              const SizedBox(width: 8),
              _buildQuickAmountButton('100%', widget.maxAmount),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: context.savoraColors.onSurface.withOpacity(0.7)),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading || _amount <= 0 || _amount > widget.maxAmount
              ? null
              : _executeTransfer,
          style: ElevatedButton.styleFrom(
            backgroundColor: SavoraColors.primary,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text('Transfer'),
        ),
      ],
    );
  }

  Widget _buildQuickAmountButton(String label, double amount) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            _amount = amount;
            _amountController.text = amount.toStringAsFixed(2);
          });
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: SavoraColors.primary,
          side: BorderSide(color: SavoraColors.primary),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(
          label,
          style: context.savoraText.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
