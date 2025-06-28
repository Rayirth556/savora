// lib/screens/game_arena_screen.dart
import 'package:flutter/material.dart';
import '../models/game_model.dart';

class GameArenaScreen extends StatefulWidget {
  final Game game;

  const GameArenaScreen({super.key, required this.game});

  @override
  State<GameArenaScreen> createState() => _GameArenaScreenState();
}

class _GameArenaScreenState extends State<GameArenaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.title),
        backgroundColor: widget.game.color,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildGameHeader(),
            const SizedBox(height: 24),
            Expanded(
              child: _buildGameContent(),
            ),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGameHeader() {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              widget.game.color.withOpacity(0.8),
              widget.game.color.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(
                widget.game.icon,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.game.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.game.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameContent() {
    switch (widget.game.type) {
      case GameType.budgetChallenge:
        return _buildBudgetChallenge();
      case GameType.investmentSimulation:
        return _buildInvestmentSimulation();
      case GameType.savingsGoal:
        return _buildSavingsGoal();
      default:
        return _buildComingSoon();
    }
  }

  Widget _buildBudgetChallenge() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(
              Icons.account_balance_wallet,
              size: 64,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            const Text(
              'Budget Challenge',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Create and manage a monthly budget with realistic income and expenses. Make smart choices to maximize your savings!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildFeatureList([
              'Set up monthly income',
              'Allocate expenses by category',
              'Handle unexpected costs',
              'Track your savings rate',
              'Earn bonus points for smart decisions',
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestmentSimulation() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(
              Icons.trending_up,
              size: 64,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            const Text(
              'Investment Simulator',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Learn investment basics through a risk-free simulation. Build a diversified portfolio and watch it grow over time!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildFeatureList([
              'Start with virtual \$10,000',
              'Choose from stocks, bonds, ETFs',
              'Learn about diversification',
              'See compound growth over time',
              'Understand risk vs. reward',
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsGoal() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(
              Icons.savings,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            const Text(
              'Savings Goal Planner',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Set realistic savings goals and create a plan to achieve them. Learn strategies to save faster and stay motivated!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildFeatureList([
              'Set short and long-term goals',
              'Calculate required monthly savings',
              'Track your progress',
              'Get motivational tips',
              'Celebrate milestones',
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildComingSoon() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Coming Soon!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This exciting game mode is under development. Check back soon for more financial learning adventures!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList(List<String> features) {
    return Column(
      children: features.map((feature) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: widget.game.color,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                feature,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildActionButton() {
    final isComingSoon = widget.game.type != GameType.budgetChallenge &&
                         widget.game.type != GameType.investmentSimulation &&
                         widget.game.type != GameType.savingsGoal;

    return ElevatedButton(
      onPressed: isComingSoon ? null : _startGame,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.game.color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        isComingSoon ? 'Coming Soon' : 'Start Game',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _startGame() {
    // Show a placeholder dialog for now
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.game.title),
        content: const Text('This game mode is being developed! You would earn XP and coins for completing it.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to game screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
