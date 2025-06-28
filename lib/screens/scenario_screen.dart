// lib/screens/scenario_screen.dart
import 'package:flutter/material.dart';
import '../models/game_model.dart';

class Scenario {
  final String title;
  final String description;
  final String situation;
  final List<ScenarioOption> options;
  final String backgroundImage;

  Scenario({
    required this.title,
    required this.description,
    required this.situation,
    required this.options,
    this.backgroundImage = '',
  });
}

class ScenarioOption {
  final String text;
  final int points;
  final String feedback;
  final bool isCorrect;

  ScenarioOption({
    required this.text,
    required this.points,
    required this.feedback,
    this.isCorrect = false,
  });
}

class ScenarioScreen extends StatefulWidget {
  final Game game;

  const ScenarioScreen({super.key, required this.game});

  @override
  State<ScenarioScreen> createState() => _ScenarioScreenState();
}

class _ScenarioScreenState extends State<ScenarioScreen> {
  int _currentScenarioIndex = 0;
  int _totalScore = 0;
  bool _hasSelectedOption = false;
  ScenarioOption? _selectedOption;

  final List<Scenario> _scenarios = [
    Scenario(
      title: "Coffee Shop Dilemma",
      description: "You're walking to work and pass your favorite coffee shop...",
      situation: "You have \$50 budgeted for the week for lunch and coffee. It's Wednesday, and you've already spent \$30. Your favorite coffee shop has a new \$8 specialty drink that looks amazing. What do you do?",
      options: [
        ScenarioOption(
          text: "Buy the specialty drink - you deserve it!",
          points: 0,
          feedback: "This would leave you with only \$12 for the rest of the week. Consider if this aligns with your budget goals.",
          isCorrect: false,
        ),
        ScenarioOption(
          text: "Order a regular coffee instead (\$3)",
          points: 15,
          feedback: "Great choice! You satisfied your coffee craving while staying within budget. You'll have \$17 left for the rest of the week.",
          isCorrect: true,
        ),
        ScenarioOption(
          text: "Skip coffee today and save the money",
          points: 20,
          feedback: "Excellent self-control! You're prioritizing your budget goals. Maybe treat yourself on Friday if you stay on track.",
          isCorrect: true,
        ),
        ScenarioOption(
          text: "Buy the drink and adjust next week's budget",
          points: 5,
          feedback: "This shows awareness but creates a pattern of overspending. Try to stick to your current budget when possible.",
          isCorrect: false,
        ),
      ],
    ),
    Scenario(
      title: "Online Shopping Temptation",
      description: "You receive an email about a flash sale...",
      situation: "Your favorite online store is having a 50% off flash sale that ends in 2 hours. You see a jacket you've wanted for \$60 (originally \$120). However, you already spent your clothing budget for the month. What's your move?",
      options: [
        ScenarioOption(
          text: "Buy it now - 50% off is a great deal!",
          points: 0,
          feedback: "Sales can be tempting, but buying outside your budget defeats the purpose of budgeting. The deal isn't worth it if you can't afford it.",
          isCorrect: false,
        ),
        ScenarioOption(
          text: "Add it to a wishlist for next month",
          points: 20,
          feedback: "Smart thinking! If you still want it next month and have budgeted for it, then it's a planned purchase.",
          isCorrect: true,
        ),
        ScenarioOption(
          text: "Buy it and reduce next month's clothing budget",
          points: 10,
          feedback: "This shows planning, but borrowing from future budgets can become a dangerous habit.",
          isCorrect: false,
        ),
        ScenarioOption(
          text: "Look for a similar item at a lower price",
          points: 15,
          feedback: "Good alternative thinking! Sometimes you can find similar items that fit your current budget.",
          isCorrect: true,
        ),
      ],
    ),
    Scenario(
      title: "Emergency Expense",
      description: "Your car breaks down unexpectedly...",
      situation: "Your car needs a \$400 repair to pass inspection. You have \$200 in your emergency fund and \$150 in your checking account. Your monthly income is \$2000. What's the best approach?",
      options: [
        ScenarioOption(
          text: "Put it on a credit card and pay minimum payments",
          points: 5,
          feedback: "This creates debt with interest. Only consider this if you have a plan to pay it off quickly.",
          isCorrect: false,
        ),
        ScenarioOption(
          text: "Use emergency fund + checking account money",
          points: 20,
          feedback: "Perfect! This is exactly what an emergency fund is for. Make sure to rebuild your emergency fund as a priority.",
          isCorrect: true,
        ),
        ScenarioOption(
          text: "Ask family for a loan",
          points: 10,
          feedback: "This could work if family is willing, but using your emergency fund is what it's designed for.",
          isCorrect: false,
        ),
        ScenarioOption(
          text: "Look for a cheaper mechanic or second opinion",
          points: 15,
          feedback: "Smart to get a second opinion! But don't delay necessary repairs. Safety comes first.",
          isCorrect: true,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scenario = _scenarios[_currentScenarioIndex];
    final isLastScenario = _currentScenarioIndex == _scenarios.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.title),
        backgroundColor: widget.game.color,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProgressBar(),
              const SizedBox(height: 20),
              _buildScenarioCard(scenario),
              const SizedBox(height: 20),
              _buildOptionsSection(scenario),
              if (_hasSelectedOption) ...[
                const SizedBox(height: 20),
                _buildFeedbackCard(),
                const SizedBox(height: 20),
                _buildActionButton(isLastScenario),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Scenario ${_currentScenarioIndex + 1}/${_scenarios.length}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: widget.game.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, size: 16, color: widget.game.color),
                  const SizedBox(width: 4),
                  Text(
                    'Score: $_totalScore',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: widget.game.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (_currentScenarioIndex + 1) / _scenarios.length,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(widget.game.color),
        ),
      ],
    );
  }

  Widget _buildScenarioCard(Scenario scenario) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              widget.game.color.withOpacity(0.1),
              widget.game.color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.psychology,
                    color: widget.game.color,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      scenario.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                scenario.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  scenario.situation,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsSection(Scenario scenario) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What would you do?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...scenario.options.asMap().entries.map(
          (entry) => _buildOptionCard(entry.key, entry.value),
        ),
      ],
    );
  }

  Widget _buildOptionCard(int index, ScenarioOption option) {
    final isSelected = _selectedOption == option;
    final hasSelected = _hasSelectedOption;

    Color? cardColor;
    Color? borderColor;
    Color? textColor = Colors.black87;

    if (hasSelected && isSelected) {
      if (option.isCorrect) {
        cardColor = Colors.green[50];
        borderColor = Colors.green;
      } else {
        cardColor = Colors.orange[50];
        borderColor = Colors.orange;
      }
    } else if (hasSelected && option.isCorrect) {
      cardColor = Colors.green[50];
      borderColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        color: cardColor,
        elevation: isSelected ? 4 : 2,
        child: InkWell(
          onTap: hasSelected ? null : () => _selectOption(option),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: borderColor != null ? Border.all(color: borderColor, width: 2) : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: borderColor ?? Colors.grey[300],
                    radius: 16,
                    child: Text(
                      String.fromCharCode(65 + index),
                      style: TextStyle(
                        color: borderColor != null ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      option.text,
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (hasSelected && option.isCorrect)
                    const Icon(Icons.check_circle, color: Colors.green),
                  if (hasSelected && isSelected && !option.isCorrect)
                    const Icon(Icons.info, color: Colors.orange),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackCard() {
    if (_selectedOption == null) return const SizedBox.shrink();

    return Card(
      color: _selectedOption!.isCorrect ? Colors.green[50] : Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _selectedOption!.isCorrect ? Icons.check_circle : Icons.lightbulb,
                  color: _selectedOption!.isCorrect ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedOption!.isCorrect ? 'Great Choice!' : 'Learning Moment',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.game.color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+${_selectedOption!.points} pts',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _selectedOption!.feedback,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(bool isLastScenario) {
    return ElevatedButton(
      onPressed: isLastScenario ? _finishScenarios : _nextScenario,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.game.color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        isLastScenario ? 'Finish Challenge' : 'Next Scenario',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _selectOption(ScenarioOption option) {
    setState(() {
      _selectedOption = option;
      _hasSelectedOption = true;
      _totalScore += option.points;
    });
  }

  void _nextScenario() {
    setState(() {
      _currentScenarioIndex++;
      _hasSelectedOption = false;
      _selectedOption = null;
    });
  }

  void _finishScenarios() {
    final maxPossibleScore = _scenarios.length * 20; // Assuming max 20 points per scenario
    final percentage = (_totalScore / maxPossibleScore * 100).round();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Challenge Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              percentage >= 80 ? Icons.star : Icons.thumb_up,
              size: 64,
              color: percentage >= 80 ? Colors.amber : Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              'Your Score: $_totalScore/$maxPossibleScore ($percentage%)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'XP Earned: ${widget.game.xpReward}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Coins Earned: ${widget.game.coinsReward}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to game screen
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
