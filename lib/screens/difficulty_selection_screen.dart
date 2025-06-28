import 'package:flutter/material.dart';
import 'financial_survival_quest_expert.dart';

enum GameDifficulty {
  beginner(
    displayName: 'Beginner',
    description: 'Gentle introduction to financial concepts\nSmaller stakes, helpful hints',
    icon: Icons.child_friendly,
    color: Color(0xFF4CAF50),
    multiplier: 0.7,
  ),
  intermediate(
    displayName: 'Intermediate', 
    description: 'Balanced challenges with moderate complexity\nReal-world scenarios, standard stakes',
    icon: Icons.school,
    color: Color(0xFF2196F3),
    multiplier: 1.0,
  ),
  expert(
    displayName: 'Expert',
    description: 'Complex real-life financial scenarios\nHigh stakes, no safety nets',
    icon: Icons.psychology,
    color: Color(0xFFFF5722),
    multiplier: 1.5,
  ),
  master(
    displayName: 'Master',
    description: 'Extreme financial challenges\nUnforgiving outcomes, expert-level decisions',
    icon: Icons.whatshot,
    color: Color(0xFF9C27B0),
    multiplier: 2.0,
  );

  const GameDifficulty({
    required this.displayName,
    required this.description,
    required this.icon,
    required this.color,
    required this.multiplier,
  });

  final String displayName;
  final String description;
  final IconData icon;
  final Color color;
  final double multiplier;
}

class DifficultySelectionScreen extends StatefulWidget {
  const DifficultySelectionScreen({Key? key}) : super(key: key);

  @override
  State<DifficultySelectionScreen> createState() => _DifficultySelectionScreenState();
}

class _DifficultySelectionScreenState extends State<DifficultySelectionScreen>
    with TickerProviderStateMixin {
  GameDifficulty? selectedDifficulty;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.shade900,
              Colors.purple.shade800,
              Colors.deepPurple.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _buildDifficultyOptions(),
                ),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Icon(
              Icons.psychology_alt,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Choose Your Challenge',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select difficulty level for your financial life simulation',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ListView.builder(
        itemCount: GameDifficulty.values.length,
        itemBuilder: (context, index) {
          final difficulty = GameDifficulty.values[index];
          final isSelected = selectedDifficulty == difficulty;
          
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (index * 100)),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 50 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: _buildDifficultyCard(difficulty, isSelected),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDifficultyCard(GameDifficulty difficulty, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDifficulty = difficulty;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected 
              ? difficulty.color.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? difficulty.color 
                : Colors.white.withOpacity(0.1),
            width: 2,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: difficulty.color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: difficulty.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                difficulty.icon,
                color: difficulty.color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    difficulty.displayName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? difficulty.color : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    difficulty.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 16,
                        color: difficulty.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${(difficulty.multiplier * 100).toInt()}% stakes',
                        style: TextStyle(
                          fontSize: 12,
                          color: difficulty.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: difficulty.color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: selectedDifficulty != null ? _proceedToGame : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedDifficulty?.color ?? Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: selectedDifficulty != null ? 4 : 0,
              ),
              child: Text(
                selectedDifficulty != null 
                    ? 'Start ${selectedDifficulty!.displayName} Mode'
                    : 'Select Difficulty Level',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Back to Dashboard',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToGame() {
    if (selectedDifficulty != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FinancialSurvivalQuest(
            difficulty: selectedDifficulty!,
          ),
        ),
      );
    }
  }
}
