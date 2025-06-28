// lib/models/game_model.dart
import 'package:flutter/material.dart';

enum GameType {
  quiz,
  budgetChallenge,
  spendingScenario,
  investmentSimulation,
  savingsGoal,
  lifeSimulator,
  towerDefense,
  stockBattleRoyale,
  financialRPG
}

enum GameDifficulty {
  easy,
  medium,
  hard
}

class Game {
  final String id;
  final String title;
  final String description;
  final GameType type;
  final GameDifficulty difficulty;
  final int xpReward;
  final int coinsReward;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final int requiredLevel;
  final Duration estimatedTime;

  const Game({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.xpReward,
    required this.coinsReward,
    required this.icon,
    required this.color,
    this.isUnlocked = true,
    this.requiredLevel = 1,
    required this.estimatedTime,
  });
}

class GameProgress {
  final String gameId;
  final int highScore;
  final int timesPlayed;
  final DateTime lastPlayed;
  final bool isCompleted;
  final Map<String, dynamic> gameData;

  GameProgress({
    required this.gameId,
    this.highScore = 0,
    this.timesPlayed = 0,
    required this.lastPlayed,
    this.isCompleted = false,
    this.gameData = const {},
  });

  Map<String, dynamic> toJson() => {
    'gameId': gameId,
    'highScore': highScore,
    'timesPlayed': timesPlayed,
    'lastPlayed': lastPlayed.toIso8601String(),
    'isCompleted': isCompleted,
    'gameData': gameData,
  };

  factory GameProgress.fromJson(Map<String, dynamic> json) => GameProgress(
    gameId: json['gameId'],
    highScore: json['highScore'] ?? 0,
    timesPlayed: json['timesPlayed'] ?? 0,
    lastPlayed: DateTime.parse(json['lastPlayed']),
    isCompleted: json['isCompleted'] ?? false,
    gameData: json['gameData'] ?? {},
  );
}

// Sample games data
class GameData {
  static List<Game> getAllGames() {
    return [
      const Game(
        id: 'life_simulation',
        title: 'Life Simulation',
        description: 'Navigate through life\'s financial challenges! Make smart decisions from teenage years through retirement to build wealth and happiness.',
        type: GameType.lifeSimulator,
        difficulty: GameDifficulty.easy,
        xpReward: 250,
        coinsReward: 400,
        icon: Icons.timeline,
        color: Colors.purple,
        estimatedTime: Duration(minutes: 15),
      ),
    ];
  }
}
