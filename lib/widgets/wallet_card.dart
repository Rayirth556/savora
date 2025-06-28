import 'package:flutter/material.dart';
import '../theme/savora_theme.dart';
import '../models/transaction_model.dart';

class WalletCard extends StatelessWidget {
  final double balance;
  final String currency;
  final bool showBalance;
  final VoidCallback? onHistory;
  final void Function(Transaction)? onTransaction;

  const WalletCard({
    super.key,
    required this.balance,
    this.currency = '₹',
    this.showBalance = true,
    this.onHistory,
    this.onTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: SavoraColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: SavoraColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SAVORA WALLET',
                      style: context.savoraText.labelMedium?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white.withOpacity(0.8),
                      size: 24,
                    ),
                  ],
                ),
                const Spacer(),
                if (showBalance) ...[
                  Text(
                    'Available Balance',
                    style: context.savoraText.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$currency${balance.toStringAsFixed(2)}',
                    style: context.savoraText.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ] else ...[
                  Text(
                    'Tap to view balance',
                    style: context.savoraText.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickAction(
                      context,
                      Icons.send,
                      'Send',
                      () => _showSendMoneyModal(context),
                    ),
                    _buildQuickAction(
                      context,
                      Icons.qr_code,
                      'Scan',
                      () => _showMockQRScanDialog(context),
                    ),
                    _buildQuickAction(
                      context,
                      Icons.history,
                      'History',
                      onHistory ?? () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: context.savoraText.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSendMoneyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.savoraColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'UPI Money Transfer',
                              style: context.savoraText.headlineMedium?.copyWith(
                                color: context.savoraColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search, color: context.savoraColors.primary),
                            hintText: 'Enter Name or Mobile Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: context.savoraColors.primary.withOpacity(0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: context.savoraColors.primary, width: 2),
                            ),
                            filled: true,
                            fillColor: context.savoraColors.surface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Text(
                            'Recommended',
                            style: context.savoraText.titleMedium?.copyWith(
                              color: context.savoraColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ..._mockContacts.map((contact) => ListTile(
                              leading: CircleAvatar(
                                backgroundColor: SavoraColors.primary.withOpacity(0.1),
                                child: Text(
                                  contact['initials']!,
                                  style: context.savoraText.titleMedium?.copyWith(
                                    color: SavoraColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                contact['name']!,
                                style: context.savoraText.titleMedium,
                              ),
                              subtitle: Text(
                                contact['number']!,
                                style: context.savoraText.bodySmall,
                              ),
                              onTap: () {
                                Navigator.pop(context); // Close contact list
                                _showAmountEntryModal(context, contact);
                              },
                            )),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showAmountEntryModal(BuildContext context, Map<String, String> contact) {
    final TextEditingController amountController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.savoraColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: SavoraColors.primary.withOpacity(0.1),
                      child: Text(
                        contact['initials']!,
                        style: context.savoraText.titleMedium?.copyWith(
                          color: SavoraColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact['name']!,
                          style: context.savoraText.titleLarge,
                        ),
                        Text(
                          contact['number']!,
                          style: context.savoraText.bodySmall,
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    prefixText: '₹',
                    labelText: 'Enter Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.savoraColors.primary.withOpacity(0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.savoraColors.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: context.savoraColors.surface,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SavoraColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if (onTransaction != null && amountController.text.isNotEmpty) {
                        final tx = Transaction(
                          amount: double.tryParse(amountController.text) ?? 0,
                          category: contact['name'] ?? 'Unknown',
                          date: DateTime.now(),
                        );
                        onTransaction!(tx);
                      }
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Icon(Icons.check_circle, color: Colors.green, size: 48),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Money Sent!',
                                style: context.savoraText.headlineMedium?.copyWith(
                                  color: SavoraColors.success,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '₹${amountController.text} sent to ${contact['name']}',
                                style: context.savoraText.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      'Send',
                      style: context.savoraText.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMockQRScanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.qr_code_scanner, color: SavoraColors.primary),
              const SizedBox(width: 8),
              Text('Scan QR Code', style: context.savoraText.titleLarge),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Simulate scanning a QR code.\nProceed to send money to:',
                style: context.savoraText.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                backgroundColor: SavoraColors.primary.withOpacity(0.1),
                child: Text('QR', style: context.savoraText.titleMedium?.copyWith(color: SavoraColors.primary, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Text('Demo UPI ID', style: context.savoraText.titleMedium),
              Text('demo@upi', style: context.savoraText.bodySmall),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SavoraColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context);
                _showAmountEntryModal(context, {
                  'initials': 'QR',
                  'name': 'Demo UPI ID',
                  'number': 'demo@upi',
                });
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
  }
}

// Mock contacts for demonstration
const List<Map<String, String>> _mockContacts = [
  {'initials': 'AD', 'name': 'Aarush Didi', 'number': '+91 9258409065'},
  {'initials': 'A', 'name': 'Aarushi', 'number': '+91 8383941894'},
  {'initials': 'AP', 'name': 'Aarushi Personal', 'number': '+91 9015455968'},
  {'initials': 'A', 'name': 'Aaushi (roommate)', 'number': '+91 9549245885'},
  {'initials': 'AB', 'name': 'Abhay @ Family', 'number': '+91 9971257387'},
  {'initials': 'A', 'name': 'Abhaya', 'number': '+91 9769678276'},
  {'initials': 'AB', 'name': 'Abhinav Bhargava @ Family', 'number': '+91 9540951831'},
  {'initials': 'AI', 'name': 'Abhinav IT', 'number': '+91 9428551917'},
  {'initials': 'AI', 'name': 'Abhinaya IT', 'number': '+91 8838377267'},
];
