// lib/widgets/xp_streak_bar.dart
import 'package:flutter/material.dart';

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
                _buildXPSection(progress),
                _buildStreakSection(),
              ],
            ),
            const SizedBox(height: 12),
            _buildProgressBar(progress),
          ],
        ),
      ),
    );
  }

  Widget _buildXPSection(double progress) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                'Level $currentLevel',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$currentXP / $nextLevelXP XP',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
          const SizedBox(width: 4),
          Text(
            '$streakDays day${streakDays != 1 ? 's' : ''}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress to Level ${currentLevel + 1}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
          minHeight: 6,
        ),
      ],
    );
  }
}
