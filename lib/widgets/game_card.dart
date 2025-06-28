// lib/widgets/game_card.dart
import 'package:flutter/material.dart';
import '../models/game_model.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final GameProgress? progress;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.game,
    this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlocked = game.isUnlocked;
    final hasProgress = progress != null;

    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isUnlocked ? onTap : null,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isUnlocked 
                ? [game.color.withOpacity(0.8), game.color.withOpacity(0.6)]
                : [Colors.grey.withOpacity(0.5), Colors.grey.withOpacity(0.3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      game.icon,
                      size: 32,
                      color: isUnlocked ? Colors.white : Colors.grey,
                    ),
                    const Spacer(),
                    if (!isUnlocked)
                      const Icon(
                        Icons.lock,
                        color: Colors.grey,
                        size: 20,
                      ),
                    if (hasProgress && progress!.isCompleted)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 20,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  game.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? Colors.white : Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  game.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUnlocked ? Colors.white70 : Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      Icons.timer,
                      size: 16,
                      color: isUnlocked ? Colors.white70 : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${game.estimatedTime.inMinutes}min',
                      style: TextStyle(
                        fontSize: 12,
                        color: isUnlocked ? Colors.white70 : Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 14,
                            color: isUnlocked ? Colors.white : Colors.grey,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${game.xpReward}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isUnlocked ? Colors.white : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (hasProgress) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Best: ${progress!.highScore}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Played: ${progress!.timesPlayed}x',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
