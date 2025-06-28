// lib/widgets/reward_badge.dart
import 'package:flutter/material.dart';

enum BadgeType {
  bronze,
  silver,
  gold,
  diamond,
}

class RewardBadge extends StatelessWidget {
  final String title;
  final String description;
  final BadgeType type;
  final IconData icon;
  final bool isEarned;
  final VoidCallback? onTap;

  const RewardBadge({
    super.key,
    required this.title,
    required this.description,
    required this.type,
    required this.icon,
    this.isEarned = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getBadgeColor();
    
    return Card(
      elevation: isEarned ? 4 : 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isEarned 
              ? LinearGradient(
                  colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          ),
          child: Column(
            children: [
              _buildBadgeIcon(color),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isEarned ? Colors.black : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: isEarned ? Colors.grey[600] : Colors.grey[400],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeIcon(Color color) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isEarned 
          ? RadialGradient(
              colors: [color, color.withOpacity(0.7)],
            )
          : LinearGradient(
              colors: [Colors.grey[300]!, Colors.grey[400]!],
            ),
        boxShadow: isEarned 
          ? [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ]
          : null,
      ),
      child: Icon(
        isEarned ? icon : Icons.lock,
        size: 30,
        color: isEarned ? Colors.white : Colors.grey[600],
      ),
    );
  }

  Color _getBadgeColor() {
    switch (type) {
      case BadgeType.bronze:
        return const Color(0xFFCD7F32);
      case BadgeType.silver:
        return const Color(0xFFC0C0C0);
      case BadgeType.gold:
        return const Color(0xFFFFD700);
      case BadgeType.diamond:
        return const Color(0xFFB9F2FF);
    }
  }
}

class BadgeShowcase extends StatelessWidget {
  final List<RewardBadge> badges;

  const BadgeShowcase({super.key, required this.badges});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Achievements',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: badges.length,
            itemBuilder: (context, index) {
              return Container(
                width: 120,
                margin: const EdgeInsets.only(right: 12),
                child: badges[index],
              );
            },
          ),
        ),
      ],
    );
  }
}

// Sample badges data
class BadgeData {
  static List<RewardBadge> getAvailableBadges() {
    return [
      const RewardBadge(
        title: 'First Steps',
        description: 'Complete your first quiz',
        type: BadgeType.bronze,
        icon: Icons.quiz,
        isEarned: true,
      ),
      const RewardBadge(
        title: 'Budget Master',
        description: 'Create 5 successful budgets',
        type: BadgeType.silver,
        icon: Icons.account_balance_wallet,
        isEarned: false,
      ),
      const RewardBadge(
        title: 'Savings Star',
        description: 'Reach a savings goal',
        type: BadgeType.gold,
        icon: Icons.savings,
        isEarned: false,
      ),
      const RewardBadge(
        title: 'Investment Pro',
        description: 'Complete investment simulation with 20% return',
        type: BadgeType.diamond,
        icon: Icons.trending_up,
        isEarned: false,
      ),
    ];
  }
}
