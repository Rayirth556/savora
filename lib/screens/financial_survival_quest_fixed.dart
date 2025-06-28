// Enhanced Financial Survival Quest with White/Black Theme and Step-by-Step Flow
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

// Enhanced life stages with detailed progression
enum LifeStage {
  teen(displayName: 'Teenager', icon: Icons.school, color: Color(0xFF4CAF50)),
  college(displayName: 'College Student', icon: Icons.menu_book, color: Color(0xFF2196F3)),
  firstJob(displayName: 'First Job', icon: Icons.work, color: Color(0xFF9C27B0)),
  marriage(displayName: 'Marriage', icon: Icons.favorite, color: Color(0xFFE91E63)),
  homeOwner(displayName: 'Home Owner', icon: Icons.home, color: Color(0xFFFF9800)),
  parenthood(displayName: 'Parenthood', icon: Icons.child_care, color: Color(0xFF795548)),
  careerPeak(displayName: 'Career Peak', icon: Icons.trending_up, color: Color(0xFF607D8B)),
  preRetirement(displayName: 'Pre-Retirement', icon: Icons.savings, color: Color(0xFF3F51B5)),
  retirement(displayName: 'Retirement', icon: Icons.beach_access, color: Color(0xFF009688));

  const LifeStage({
    required this.displayName,
    required this.icon,
    required this.color,
  });

  final String displayName;
  final IconData icon;
  final Color color;
}

// Enhanced difficulty levels
enum GameDifficulty {
  easy(displayName: 'Easy Mode', description: 'Basic financial scenarios', multiplier: 1.0),
  medium(displayName: 'Medium Mode', description: 'Real-world challenges', multiplier: 1.5),
  hard(displayName: 'Hard Mode', description: 'Economic downturns & crises', multiplier: 2.0),
  expert(displayName: 'Expert Mode', description: 'Complex market scenarios', multiplier: 3.0);

  const GameDifficulty({
    required this.displayName,
    required this.description,
    required this.multiplier,
  });

  final String displayName;
  final String description;
  final double multiplier;
}

// Enhanced Achievement System
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int requiredValue;
  final String category;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.requiredValue,
    required this.category,
    this.unlockedAt,
  });

  Achievement copyWith({DateTime? unlockedAt}) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      icon: icon,
      color: color,
      requiredValue: requiredValue,
      category: category,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}

// Enhanced Financial Character
class FinancialCharacter {
  final String name;
  final LifeStage currentStage;
  final int age;
  final double savings;
  final int creditScore;
  final int xp;
  final int stress;
  final double income;
  final int happiness;
  final int knowledge;
  final List<Achievement> unlockedAchievements;
  final Map<String, dynamic> lifeEvents;

  const FinancialCharacter({
    required this.name,
    required this.currentStage,
    required this.age,
    required this.savings,
    required this.creditScore,
    required this.xp,
    required this.stress,
    required this.income,
    required this.happiness,
    required this.knowledge,
    this.unlockedAchievements = const [],
    this.lifeEvents = const {},
  });

  FinancialCharacter copyWith({
    String? name,
    LifeStage? currentStage,
    int? age,
    double? savings,
    int? creditScore,
    int? xp,
    int? stress,
    double? income,
    int? happiness,
    int? knowledge,
    List<Achievement>? unlockedAchievements,
    Map<String, dynamic>? lifeEvents,
  }) {
    return FinancialCharacter(
      name: name ?? this.name,
      currentStage: currentStage ?? this.currentStage,
      age: age ?? this.age,
      savings: savings ?? this.savings,
      creditScore: creditScore ?? this.creditScore,
      xp: xp ?? this.xp,
      stress: stress ?? this.stress,
      income: income ?? this.income,
      happiness: happiness ?? this.happiness,
      knowledge: knowledge ?? this.knowledge,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      lifeEvents: lifeEvents ?? this.lifeEvents,
    );
  }

  // Calculate next life stage
  LifeStage? get nextStage {
    final stages = LifeStage.values;
    final currentIndex = stages.indexOf(currentStage);
    if (currentIndex < stages.length - 1) {
      return stages[currentIndex + 1];
    }
    return null;
  }
}

// Enhanced Life Event with difficulty scaling
class LifeEvent {
  final String id;
  final String title;
  final String description;
  final List<LifeChoice> choices;
  final List<LifeStage> applicableStages;
  final GameDifficulty difficulty;
  final String category;

  const LifeEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.choices,
    required this.applicableStages,
    required this.difficulty,
    required this.category,
  });
}

// Enhanced Life Choice with detailed impacts
class LifeChoice {
  final String text;
  final String description;
  final double moneyImpact;
  final int happinessImpact;
  final int stressImpact;
  final int knowledgeImpact;
  final int creditScoreImpact;
  final Map<String, dynamic> specialEffects;
  final String outcomeText;

  const LifeChoice({
    required this.text,
    required this.description,
    required this.moneyImpact,
    required this.happinessImpact,
    required this.stressImpact,
    required this.knowledgeImpact,
    required this.creditScoreImpact,
    this.specialEffects = const {},
    required this.outcomeText,
  });
}

// Achievement Data
class AchievementData {
  static const List<Achievement> allAchievements = [
    // Savings Achievements
    Achievement(
      id: 'savings_1k',
      title: 'Savings Starter',
      description: 'Reach \$1,000 in savings',
      icon: Icons.account_balance_wallet,
      color: Colors.green,
      requiredValue: 1000,
      category: 'savings',
    ),
    Achievement(
      id: 'savings_10k',
      title: 'Savings Master',
      description: 'Reach \$10,000 in savings',
      icon: Icons.savings,
      color: Colors.green,
      requiredValue: 10000,
      category: 'savings',
    ),
    Achievement(
      id: 'savings_100k',
      title: 'Wealth Builder',
      description: 'Reach \$100,000 in savings',
      icon: Icons.diamond,
      color: Colors.blue,
      requiredValue: 100000,
      category: 'savings',
    ),
    Achievement(
      id: 'credit_700',
      title: 'Good Credit',
      description: 'Reach a credit score of 700',
      icon: Icons.credit_score,
      color: Colors.orange,
      requiredValue: 700,
      category: 'credit',
    ),
    Achievement(
      id: 'credit_800',
      title: 'Excellent Credit',
      description: 'Reach a credit score of 800',
      icon: Icons.star,
      color: Colors.purple,
      requiredValue: 800,
      category: 'credit',
    ),
  ];
}

// Game Event Data with difficulty-based scenarios
class GameEventData {
  static List<LifeEvent> getEventsForStage(LifeStage stage, GameDifficulty difficulty) {
    return [
      LifeEvent(
        id: 'teen_first_job',
        title: 'First Part-Time Job',
        description: 'You got your first part-time job! How will you handle your first paycheck?',
        applicableStages: [LifeStage.teen],
        difficulty: difficulty,
        category: 'income',
        choices: [
          LifeChoice(
            text: 'Save 50% of earnings',
            description: 'Build good saving habits early',
            moneyImpact: 200 * difficulty.multiplier,
            happinessImpact: 5,
            stressImpact: -5,
            knowledgeImpact: 10,
            creditScoreImpact: 0,
            outcomeText: 'Great choice! Starting to save early builds excellent financial habits.',
          ),
          LifeChoice(
            text: 'Spend on wants immediately',
            description: 'Enjoy your money while you can',
            moneyImpact: -100 * difficulty.multiplier,
            happinessImpact: 15,
            stressImpact: 5,
            knowledgeImpact: -5,
            creditScoreImpact: 0,
            outcomeText: 'You enjoyed spending, but missed an opportunity to build savings.',
          ),
        ],
      ),
    ];
  }
}

// Main Game Widget
class FinancialSurvivalQuest extends StatefulWidget {
  const FinancialSurvivalQuest({super.key});

  @override
  State<FinancialSurvivalQuest> createState() => _FinancialSurvivalQuestState();
}

class _FinancialSurvivalQuestState extends State<FinancialSurvivalQuest>
    with TickerProviderStateMixin {
  // Game State
  FinancialCharacter? character;
  GameDifficulty selectedDifficulty = GameDifficulty.easy;
  LifeEvent? currentEvent;
  bool gameStarted = false;
  bool showingResult = false;
  String lastChoiceOutcome = '';
  String characterName = '';
  int currentStep = 0; // 0: difficulty, 1: character creation
  Set<String> completedEventIds = {}; // Track completed events
  
  // Controllers for animations and text input
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late TextEditingController _nameController;
  
  // Theme colors
  static const Color primaryBlack = Color(0xFF1A1A1A);
  static const Color primaryWhite = Color(0xFFFAFAFA);
  static const Color accentGray = Color(0xFF2D2D2D);
  static const Color lightGray = Color(0xFFE0E0E0);

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _nameController = TextEditingController();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhite,
      body: SafeArea(
        child: gameStarted ? _buildGameScreen() : _buildStartScreen(),
      ),
    );
  }

  Widget _buildStartScreen() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryWhite, Color(0xFFF5F5F5)],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 40),
            if (currentStep == 0) ...[
              _buildDifficultySelection(),
              const SizedBox(height: 40),
              _buildDifficultyNextButton(),
            ] else if (currentStep == 1) ...[
              _buildCharacterCreation(),
              const SizedBox(height: 40),
              _buildStartButton(),
            ],
            const SizedBox(height: 20), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryBlack,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: currentStep > 0 
                    ? () => setState(() => currentStep--) 
                    : () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: primaryWhite),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Financial Survival Quest',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryWhite,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentStep == 0 
                          ? 'Step 1: Choose Difficulty' 
                          : 'Step 2: Create Character',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFB0B0B0),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Navigate through life\'s financial challenges and build wealth through smart decisions.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFB0B0B0),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Progress indicator
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: primaryWhite,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: currentStep >= 1 
                        ? primaryWhite 
                        : primaryWhite.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySelection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: lightGray),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Difficulty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryBlack,
            ),
          ),
          const SizedBox(height: 16),
          ...GameDifficulty.values.map(_buildDifficultyOption),
        ],
      ),
    );
  }

  Widget _buildDifficultyOption(GameDifficulty difficulty) {
    final isSelected = selectedDifficulty == difficulty;
    return GestureDetector(
      onTap: () => setState(() => selectedDifficulty = difficulty),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlack : accentGray.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryBlack : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? primaryWhite : primaryBlack,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    difficulty.displayName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? primaryWhite : primaryBlack,
                    ),
                  ),
                  Text(
                    difficulty.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected 
                          ? primaryWhite.withOpacity(0.8) 
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected 
                    ? primaryWhite.withOpacity(0.2) 
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${difficulty.multiplier}x',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? primaryWhite : primaryBlack,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyNextButton() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryBlack, accentGray],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryBlack.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => setState(() => currentStep = 1),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue to Character Creation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryWhite,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: primaryWhite),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterCreation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: lightGray),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Your Character',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryBlack,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Character Name',
              labelStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: lightGray),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primaryBlack, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            onChanged: (value) {
              setState(() {
                characterName = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    final isEnabled = characterName.trim().isNotEmpty;
    
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEnabled 
              ? [primaryBlack, accentGray]
              : [Colors.grey[400]!, Colors.grey[300]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isEnabled ? primaryBlack : Colors.grey).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isEnabled ? _startGame : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          isEnabled 
              ? 'Begin Your Financial Journey'
              : 'Enter your name to start',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryWhite,
          ),
        ),
      ),
    );
  }

  Widget _buildGameScreen() {
    if (character == null) return const SizedBox();
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryWhite, Color(0xFFF5F5F5)],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildGameHeader(),
            const SizedBox(height: 24),
            _buildCharacterStats(),
            const SizedBox(height: 24),
            if (currentEvent != null) ...[
              _buildEventCard(),
              const SizedBox(height: 24),
            ],
            if (showingResult) _buildResultCard(),
            if (currentEvent == null && !showingResult) _buildNextEventButton(),
            const SizedBox(height: 24),
            _buildAchievements(),
          ],
        ),
      ),
    );
  }

  void _startGame() {
    if (characterName.trim().isEmpty) return;
    
    setState(() {
      character = FinancialCharacter(
        name: characterName.trim(),
        currentStage: LifeStage.teen,
        age: 16,
        savings: 500,
        creditScore: 650,
        xp: 0,
        stress: 50,
        income: 0,
        happiness: 75,
        knowledge: 25,
      );
      gameStarted = true;
      completedEventIds.clear(); // Reset completed events for new game
      
      // Start the first event
      _nextEvent();
    });
  }

  Widget _buildGameHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryBlack,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: primaryWhite),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  character!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryWhite,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      character!.currentStage.icon,
                      color: character!.currentStage.color,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${character!.currentStage.displayName} • Age ${character!.age}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFFB0B0B0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Difficulty badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: selectedDifficulty == GameDifficulty.easy ? Colors.green :
                           selectedDifficulty == GameDifficulty.medium ? Colors.orange :
                           selectedDifficulty == GameDifficulty.hard ? Colors.red : Colors.purple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    selectedDifficulty.displayName.split(' ')[0],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: primaryWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildCharacterStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: lightGray),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatRow('Savings', '\$${character!.savings.toStringAsFixed(0)}', 
                       character!.savings / 100000, Colors.green),
          _buildStatRow('Credit Score', '${character!.creditScore}', 
                       character!.creditScore / 850, Colors.blue),
          _buildStatRow('Happiness', '${character!.happiness}%', 
                       character!.happiness / 100, Colors.orange),
          _buildStatRow('Knowledge', '${character!.knowledge}%', 
                       character!.knowledge / 100, Colors.purple),
          _buildStatRow('Stress', '${character!.stress}%', 
                       character!.stress / 100, Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primaryBlack,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: lightGray,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: lightGray),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryBlack,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.event, color: primaryWhite, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  currentEvent!.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryBlack,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: lightGray),
            ),
            child: Text(
              currentEvent!.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
                color: primaryBlack,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...currentEvent!.choices.map((choice) => _buildChoiceButton(choice)),
        ],
      ),
    );
  }

  Widget _buildChoiceButton(LifeChoice choice) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: () => _makeChoice(choice),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryWhite,
          foregroundColor: primaryBlack,
          side: const BorderSide(color: primaryBlack, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              choice.text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryBlack,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              choice.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryBlack,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle, color: primaryWhite, size: 24),
              SizedBox(width: 12),
              Text(
                'Result',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryWhite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            lastChoiceOutcome,
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
              color: primaryWhite,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _nextEvent,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryWhite,
              foregroundColor: primaryBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildNextEventButton() {
    return ElevatedButton(
      onPressed: _nextEvent,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlack,
        foregroundColor: primaryWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text(
        'Next Life Event',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAchievements() {
    final recentAchievements = character!.unlockedAchievements
        .where((a) => a.unlockedAt != null)
        .toList()
      ..sort((a, b) => b.unlockedAt!.compareTo(a.unlockedAt!));

    if (recentAchievements.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: lightGray),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.emoji_events, color: primaryBlack, size: 24),
              SizedBox(width: 12),
              Text(
                'Recent Achievements',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recentAchievements.take(3).map((achievement) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(achievement.icon, color: achievement.color, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        achievement.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void _nextEvent() {
    final availableEvents = _getEventsForStage(
      character!.currentStage,
      selectedDifficulty,
    );
    
    // Filter out completed events
    final uncompletedEvents = availableEvents
        .where((event) => !completedEventIds.contains(event.id))
        .toList();
    
    // If no uncompleted events, either progress stage or use fallback
    if (uncompletedEvents.isEmpty) {
      // Check if we can progress to next stage
      if (_shouldProgressStage()) {
        final nextStage = character!.nextStage;
        if (nextStage != null) {
          setState(() {
            character = character!.copyWith(currentStage: nextStage);
            completedEventIds.clear(); // Clear completed events for new stage
          });
          _nextEvent(); // Recursively call to get event for new stage
          return;
        }
      }
      
      // If can't progress, generate a generic event or reuse events
      if (availableEvents.isNotEmpty) {
        completedEventIds.clear(); // Reset if we've done all events
        setState(() {
          currentEvent = availableEvents[Random().nextInt(availableEvents.length)];
          showingResult = false;
        });
      }
    } else {
      // Select a random uncompleted event
      setState(() {
        currentEvent = uncompletedEvents[Random().nextInt(uncompletedEvents.length)];
        showingResult = false;
      });
    }
  }

  void _makeChoice(LifeChoice choice) {
    if (character == null) return;

    // Apply choice effects
    final newSavings = (character!.savings + choice.moneyImpact).clamp(0.0, double.infinity);
    final newHappiness = (character!.happiness + choice.happinessImpact).clamp(0, 100);
    final newStress = (character!.stress + choice.stressImpact).clamp(0, 100);
    final newKnowledge = (character!.knowledge + choice.knowledgeImpact).clamp(0, 100);
    final newCreditScore = (character!.creditScore + choice.creditScoreImpact).clamp(300, 850);

    // Check for new achievements
    final newAchievements = <Achievement>[];
    for (final achievement in _allAchievements) {
      if (!character!.unlockedAchievements.any((a) => a.id == achievement.id)) {
        bool unlocked = false;
        switch (achievement.category) {
          case 'savings':
            unlocked = newSavings >= achievement.requiredValue;
            break;
          case 'credit':
            unlocked = newCreditScore >= achievement.requiredValue;
            break;
          case 'knowledge':
            unlocked = newKnowledge >= achievement.requiredValue;
            break;
        }
        if (unlocked) {
          newAchievements.add(achievement.copyWith(unlockedAt: DateTime.now()));
        }
      }
    }

    setState(() {
      character = character!.copyWith(
        savings: newSavings,
        happiness: newHappiness,
        stress: newStress,
        knowledge: newKnowledge,
        creditScore: newCreditScore,
        age: character!.age + Random().nextInt(2) + 1, // Age 1-2 years
        unlockedAchievements: [...character!.unlockedAchievements, ...newAchievements],
      );

      // Check for stage progression
      if (_shouldProgressStage()) {
        final nextStage = character!.nextStage;
        if (nextStage != null) {
          character = character!.copyWith(currentStage: nextStage);
        }
      }

      // Mark current event as completed
      if (currentEvent != null) {
        completedEventIds.add(currentEvent!.id);
      }

      lastChoiceOutcome = choice.outcomeText;
      showingResult = true;
      currentEvent = null;
    });
  }

  bool _shouldProgressStage() {
    switch (character!.currentStage) {
      case LifeStage.teen:
        return character!.age >= 18;
      case LifeStage.college:
        return character!.age >= 22;
      case LifeStage.firstJob:
        return character!.age >= 25;
      case LifeStage.marriage:
        return character!.age >= 30;
      case LifeStage.homeOwner:
        return character!.age >= 35;
      case LifeStage.parenthood:
        return character!.age >= 45;
      case LifeStage.careerPeak:
        return character!.age >= 55;
      case LifeStage.preRetirement:
        return character!.age >= 65;
      case LifeStage.retirement:
        return false; // No progression after retirement
    }
  }

  List<LifeEvent> _getEventsForStage(LifeStage stage, GameDifficulty difficulty) {
    // Sample events - in a real app, this would be a comprehensive database
    final allEvents = [
      // Teen events
      LifeEvent(
        id: 'teen_part_time_job',
        title: 'Part-Time Job Opportunity',
        description: 'A local store is offering you a part-time job after school. It pays \$10/hour for 15 hours a week.',
        choices: [
          LifeChoice(
            text: 'Take the job',
            description: 'Start earning money but less time for studies',
            moneyImpact: 600,
            happinessImpact: 10,
            stressImpact: 15,
            knowledgeImpact: 5,
            creditScoreImpact: 0,
            outcomeText: 'You took the job and earned your first paycheck! You\'re learning valuable work skills.',
          ),
          LifeChoice(
            text: 'Focus on studies',
            description: 'Prioritize education over immediate income',
            moneyImpact: 0,
            happinessImpact: 5,
            stressImpact: -5,
            knowledgeImpact: 15,
            creditScoreImpact: 0,
            outcomeText: 'You focused on your studies and improved your grades significantly.',
          ),
        ],
        applicableStages: [LifeStage.teen],
        difficulty: GameDifficulty.easy,
        category: 'work',
      ),
      
      LifeEvent(
        id: 'teen_saving_challenge',
        title: 'Saving Challenge',
        description: 'Your parents challenge you to save \$500 in 6 months. They\'ll match whatever you save.',
        choices: [
          LifeChoice(
            text: 'Accept the challenge',
            description: 'Work hard to save money',
            moneyImpact: 1000,
            happinessImpact: 15,
            stressImpact: 10,
            knowledgeImpact: 10,
            creditScoreImpact: 0,
            outcomeText: 'You successfully saved \$500 and your parents matched it! Great financial discipline.',
          ),
          LifeChoice(
            text: 'Decline the challenge',
            description: 'Don\'t commit to saving',
            moneyImpact: 0,
            happinessImpact: -5,
            stressImpact: 0,
            knowledgeImpact: 0,
            creditScoreImpact: 0,
            outcomeText: 'You missed out on the savings challenge. Maybe next time you\'ll be more motivated.',
          ),
        ],
        applicableStages: [LifeStage.teen],
        difficulty: GameDifficulty.easy,
        category: 'savings',
      ),

      // College events
      LifeEvent(
        id: 'college_credit_card',
        title: 'First Credit Card Offer',
        description: 'A bank is offering you a student credit card with a \$1000 limit and no annual fee.',
        choices: [
          LifeChoice(
            text: 'Accept and use responsibly',
            description: 'Build credit history with careful usage',
            moneyImpact: 0,
            happinessImpact: 5,
            stressImpact: 5,
            knowledgeImpact: 15,
            creditScoreImpact: 20,
            outcomeText: 'You got your first credit card and used it wisely, building good credit history.',
          ),
          LifeChoice(
            text: 'Accept and spend freely',
            description: 'Enjoy the freedom of credit',
            moneyImpact: -800,
            happinessImpact: 15,
            stressImpact: 25,
            knowledgeImpact: 5,
            creditScoreImpact: -30,
            outcomeText: 'You overspent on your credit card and learned a hard lesson about debt.',
          ),
          LifeChoice(
            text: 'Decline the offer',
            description: 'Avoid credit for now',
            moneyImpact: 0,
            happinessImpact: 0,
            stressImpact: 0,
            knowledgeImpact: 0,
            creditScoreImpact: 0,
            outcomeText: 'You decided to wait before getting a credit card. Playing it safe.',
          ),
        ],
        applicableStages: [LifeStage.college],
        difficulty: GameDifficulty.medium,
        category: 'credit',
      ),

      LifeEvent(
        id: 'college_internship',
        title: 'Summer Internship',
        description: 'You have two internship offers: one pays well but isn\'t in your field, another is unpaid but great experience.',
        choices: [
          LifeChoice(
            text: 'Take the paid internship',
            description: 'Earn money over the summer',
            moneyImpact: 3000,
            happinessImpact: 10,
            stressImpact: 10,
            knowledgeImpact: 5,
            creditScoreImpact: 0,
            outcomeText: 'You earned good money over the summer and have some savings for next year.',
          ),
          LifeChoice(
            text: 'Take the unpaid internship',
            description: 'Gain valuable experience',
            moneyImpact: -500,
            happinessImpact: 15,
            stressImpact: 5,
            knowledgeImpact: 20,
            creditScoreImpact: 0,
            outcomeText: 'You gained incredible experience and made valuable connections in your field.',
          ),
        ],
        applicableStages: [LifeStage.college],
        difficulty: GameDifficulty.medium,
        category: 'career',
      ),

      // First Job events
      LifeEvent(
        id: 'first_job_salary',
        title: 'Salary Negotiation',
        description: 'You got a job offer! The initial offer is \$45,000. Do you negotiate for more?',
        choices: [
          LifeChoice(
            text: 'Negotiate for higher salary',
            description: 'Ask for \$50,000',
            moneyImpact: 5000,
            happinessImpact: 20,
            stressImpact: 15,
            knowledgeImpact: 10,
            creditScoreImpact: 0,
            outcomeText: 'You successfully negotiated and got \$48,000! Your confidence and research paid off.',
          ),
          LifeChoice(
            text: 'Accept the initial offer',
            description: 'Take the safe route',
            moneyImpact: 0,
            happinessImpact: 10,
            stressImpact: 0,
            knowledgeImpact: 0,
            creditScoreImpact: 0,
            outcomeText: 'You accepted the offer. You\'re employed and earning a steady income.',
          ),
        ],
        applicableStages: [LifeStage.firstJob],
        difficulty: GameDifficulty.medium,
        category: 'career',
      ),

      LifeEvent(
        id: 'first_job_401k',
        title: 'Company 401(k) Plan',
        description: 'Your company offers a 401(k) with 50% matching up to 6% of your salary.',
        choices: [
          LifeChoice(
            text: 'Contribute 6% to get full match',
            description: 'Maximize the free money',
            moneyImpact: -2700,
            happinessImpact: 5,
            stressImpact: 5,
            knowledgeImpact: 15,
            creditScoreImpact: 0,
            outcomeText: 'You\'re contributing to your 401(k) and getting free money from your employer. Great start to retirement planning!',
          ),
          LifeChoice(
            text: 'Contribute 3%',
            description: 'Start small',
            moneyImpact: -1350,
            happinessImpact: 0,
            stressImpact: 0,
            knowledgeImpact: 10,
            creditScoreImpact: 0,
            outcomeText: 'You started contributing to your 401(k) but aren\'t getting the full company match.',
          ),
          LifeChoice(
            text: 'Don\'t contribute yet',
            description: 'Keep full paycheck',
            moneyImpact: 0,
            happinessImpact: -5,
            stressImpact: 0,
            knowledgeImpact: 0,
            creditScoreImpact: 0,
            outcomeText: 'You decided not to contribute to the 401(k). You\'re missing out on free money.',
          ),
        ],
        applicableStages: [LifeStage.firstJob],
        difficulty: GameDifficulty.hard,
        category: 'investment',
      ),

      // Additional Teen Events
      LifeEvent(
        id: 'teen_allowance_budget',
        title: 'Monthly Allowance Decision',
        description: 'Your parents give you \$100 monthly allowance. How will you manage it?',
        choices: [
          LifeChoice(
            text: 'Save 50%, spend 50%',
            description: 'Build good saving habits early',
            moneyImpact: 600,
            happinessImpact: 10,
            stressImpact: 0,
            knowledgeImpact: 15,
            creditScoreImpact: 0,
            outcomeText: 'You developed excellent budgeting skills by saving half your allowance!',
          ),
          LifeChoice(
            text: 'Spend it all on fun',
            description: 'Enjoy your teenage years',
            moneyImpact: 0,
            happinessImpact: 20,
            stressImpact: -5,
            knowledgeImpact: 0,
            creditScoreImpact: 0,
            outcomeText: 'You had fun but missed the opportunity to learn about saving money.',
          ),
        ],
        applicableStages: [LifeStage.teen],
        difficulty: GameDifficulty.easy,
        category: 'budgeting',
      ),

      LifeEvent(
        id: 'teen_friend_money',
        title: 'Friend Needs Money',
        description: 'Your best friend asks to borrow \$50 for a concert ticket. They promise to pay you back.',
        choices: [
          LifeChoice(
            text: 'Lend the money',
            description: 'Help your friend out',
            moneyImpact: -50,
            happinessImpact: 15,
            stressImpact: 10,
            knowledgeImpact: 5,
            creditScoreImpact: 0,
            outcomeText: 'Your friend was grateful, but you learned that lending money can strain relationships.',
          ),
          LifeChoice(
            text: 'Politely decline',
            description: 'Keep your money safe',
            moneyImpact: 0,
            happinessImpact: -5,
            stressImpact: 5,
            knowledgeImpact: 10,
            creditScoreImpact: 0,
            outcomeText: 'You learned to set financial boundaries, even with friends.',
          ),
        ],
        applicableStages: [LifeStage.teen],
        difficulty: GameDifficulty.medium,
        category: 'relationships',
      ),

      // Additional College Events
      LifeEvent(
        id: 'college_textbook_decision',
        title: 'Expensive Textbooks',
        description: 'Your required textbooks cost \$800. You have several options for getting them.',
        choices: [
          LifeChoice(
            text: 'Buy new textbooks',
            description: 'Get the latest editions',
            moneyImpact: -800,
            happinessImpact: 5,
            stressImpact: 0,
            knowledgeImpact: 5,
            creditScoreImpact: 0,
            outcomeText: 'You got the latest textbooks but spent a lot of money unnecessarily.',
          ),
          LifeChoice(
            text: 'Buy used/rent textbooks',
            description: 'Save money with used books',
            moneyImpact: -300,
            happinessImpact: 0,
            stressImpact: 0,
            knowledgeImpact: 15,
            creditScoreImpact: 0,
            outcomeText: 'You saved \$500 by being smart about textbook purchases!',
          ),
          LifeChoice(
            text: 'Use library/digital copies',
            description: 'Minimize textbook costs',
            moneyImpact: -50,
            happinessImpact: -5,
            stressImpact: 10,
            knowledgeImpact: 20,
            creditScoreImpact: 0,
            outcomeText: 'You saved almost all the money but had to work harder to access materials.',
          ),
        ],
        applicableStages: [LifeStage.college],
        difficulty: GameDifficulty.easy,
        category: 'education',
      ),

      LifeEvent(
        id: 'college_spring_break',
        title: 'Spring Break Trip',
        description: 'Friends invite you on a \$1,200 spring break trip to Miami. You have some savings.',
        choices: [
          LifeChoice(
            text: 'Go on the expensive trip',
            description: 'YOLO - make memories',
            moneyImpact: -1200,
            happinessImpact: 25,
            stressImpact: -10,
            knowledgeImpact: 0,
            creditScoreImpact: 0,
            outcomeText: 'You had an amazing time but depleted your savings significantly.',
          ),
          LifeChoice(
            text: 'Suggest a cheaper alternative',
            description: 'Propose a local trip',
            moneyImpact: -300,
            happinessImpact: 15,
            stressImpact: 0,
            knowledgeImpact: 10,
            creditScoreImpact: 0,
            outcomeText: 'You had fun on a budget trip and kept most of your savings intact.',
          ),
          LifeChoice(
            text: 'Stay home and work',
            description: 'Earn money instead of spending',
            moneyImpact: 400,
            happinessImpact: -10,
            stressImpact: 5,
            knowledgeImpact: 5,
            creditScoreImpact: 0,
            outcomeText: 'You missed the fun but earned money and learned about opportunity cost.',
          ),
        ],
        applicableStages: [LifeStage.college],
        difficulty: GameDifficulty.medium,
        category: 'lifestyle',
      ),

      // Additional First Job Events
      LifeEvent(
        id: 'first_job_emergency_fund',
        title: 'Building Emergency Fund',
        description: 'Financial experts recommend saving 3-6 months of expenses for emergencies.',
        choices: [
          LifeChoice(
            text: 'Start with 3 months target',
            description: 'Build emergency fund gradually',
            moneyImpact: -4500,
            happinessImpact: 5,
            stressImpact: -10,
            knowledgeImpact: 20,
            creditScoreImpact: 10,
            outcomeText: 'You built a solid emergency fund and feel more financially secure.',
          ),
          LifeChoice(
            text: 'Save just 1 month expenses',
            description: 'Start small',
            moneyImpact: -1500,
            happinessImpact: 0,
            stressImpact: 0,
            knowledgeImpact: 10,
            creditScoreImpact: 5,
            outcomeText: 'You started an emergency fund but it may not be enough for major emergencies.',
          ),
          LifeChoice(
            text: 'Skip emergency fund for now',
            description: 'Focus on enjoying your income',
            moneyImpact: 0,
            happinessImpact: 10,
            stressImpact: 15,
            knowledgeImpact: 0,
            creditScoreImpact: 0,
            outcomeText: 'You enjoyed your income but left yourself vulnerable to emergencies.',
          ),
        ],
        applicableStages: [LifeStage.firstJob],
        difficulty: GameDifficulty.medium,
        category: 'emergency',
      ),
    ];

    return allEvents
        .where((event) => 
            event.applicableStages.contains(stage) &&
            (difficulty == GameDifficulty.easy || 
             event.difficulty.index <= difficulty.index))
        .toList();
  }

  // Achievement data class
  static const List<Achievement> _allAchievements = [
      Achievement(
        id: 'savings_1k',
        title: 'Savings Starter',
        description: 'Reach \$1,000 in savings',
        icon: Icons.account_balance_wallet,
        color: Colors.green,
        requiredValue: 1000,
        category: 'savings',
      ),
      Achievement(
        id: 'savings_10k',
        title: 'Savings Master',
        description: 'Reach \$10,000 in savings',
        icon: Icons.savings,
        color: Colors.green,
        requiredValue: 10000,
        category: 'savings',
      ),
      Achievement(
        id: 'credit_700',
        title: 'Good Credit',
        description: 'Reach a credit score of 700',
        icon: Icons.credit_score,
        color: Colors.orange,
        requiredValue: 700,
        category: 'credit',
      ),
      Achievement(
        id: 'knowledge_50',
        title: 'Finance Student',
        description: 'Reach 50 knowledge points',
        icon: Icons.school,
        color: Colors.indigo,
        requiredValue: 50,
        category: 'knowledge',
      ),
    ];
}
