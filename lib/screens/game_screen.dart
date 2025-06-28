// lib/screens/game_screen.dart
import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../widgets/game_card.dart';
import 'quiz_screen.dart';
import 'scenario_screen.dart';
import 'game_arena_screen.dart';
import 'life_simulator_game.dart';
import 'debt_tower_defense.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final List<Game> _games = GameData.getAllGames();
  final Map<String, GameProgress> _gameProgress = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            const Text(
              'Choose Your Challenge',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _games.length,
                itemBuilder: (context, index) {
                  final game = _games[index];
                  final progress = _gameProgress[game.id];
                  
                  return GameCard(
                    game: game,
                    progress: progress,
                    onTap: () => _navigateToGame(game),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.games,
            size: 40,
            color: Colors.white,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Level Up Your Financial Skills!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Play games, earn XP, and become a money master!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToGame(Game game) {
    Widget screen;
    
    switch (game.type) {
      case GameType.quiz:
        screen = QuizScreen(game: game);
        break;
      case GameType.spendingScenario:
        screen = ScenarioScreen(game: game);
        break;
      case GameType.lifeSimulator:
        screen = const LifeSimulatorGame();
        break;
      case GameType.towerDefense:
        screen = const DebtTowerDefenseGame();
        break;
      case GameType.budgetChallenge:
      case GameType.investmentSimulation:
      case GameType.savingsGoal:
      case GameType.stockBattleRoyale:
      case GameType.financialRPG:
        screen = GameArenaScreen(game: game);
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
