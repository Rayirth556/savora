// lib/widgets/xp_streak_bar.dart
import 'package:flutter/material.dart';
import '../theme/savora_theme.dart';

class XPStreakBar extends StatelessWidget {
  final int currentXP;
  final int nextLevelXP;
  final int currentLevel;
  final int streakDays;

  const XPStreakBar({
    super.key,
    required this.currentXP,
    required this.nextLevelXP,
    required this.currentLevel,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentXP / nextLevelXP;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildXPSection(context, progress),
                _buildStreakSection(context),
              ],
            ),
            const SizedBox(height: 12),
            _buildProgressBar(context, progress),
          ],
        ),
      ),
    );
  }

  Widget _buildXPSection(BuildContext context, double progress) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: SavoraColors.xpColor, size: 20),
              const SizedBox(width: 4),
              Text(
                'Level $currentLevel',
                style: context.savoraText.titleLarge?.copyWith(
                  color: SavoraColors.levelColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$currentXP / $nextLevelXP XP',
            style: context.savoraText.bodyMedium?.copyWith(
              color: context.savoraColors.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: SavoraColors.streakColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, color: SavoraColors.streakColor, size: 20),
          const SizedBox(width: 4),
          Text(
            '$streakDays day${streakDays != 1 ? 's' : ''}',
            style: context.savoraText.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: SavoraColors.streakColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, double progress) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress to Level ${currentLevel + 1}',
              style: context.savoraText.bodySmall?.copyWith(
                color: context.savoraColors.onSurface.withOpacity(0.7),
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: context.savoraText.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.savoraColors.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: context.savoraColors.onSurface.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(SavoraColors.xpColor),
          minHeight: 6,
        ),
      ],
    );
  }
}
