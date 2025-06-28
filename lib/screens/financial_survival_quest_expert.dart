// Enhanced Financial Survival Quest - Expert Level India-Focused Life Simulation
import 'package:flutter/material.dart';
import 'dart:math';

// Life stages with detailed progression
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
}

// Enhanced Life Event with expert-level complexity
class LifeEvent {
  final String id;
  final String title;
  final String description;
  final List<LifeChoice> choices;
  final List<LifeStage> applicableStages;
  final String category;
  final String? followUpEventId; // For chained events

  const LifeEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.choices,
    required this.applicableStages,
    required this.category,
    this.followUpEventId,
  });
}

// Enhanced Life Choice with detailed impacts and chaining
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
  final String? triggersEventId; // For chained events

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
    this.triggersEventId,
  });
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
  LifeStage selectedLifeStage = LifeStage.teen;
  LifeEvent? currentEvent;
  bool gameStarted = false;
  bool showingResult = false;
  String lastChoiceOutcome = '';
  String characterName = '';
  int currentStep = 0; // 0: life stage selection, 1: character creation
  Set<String> completedEventIds = {}; // Track completed events to avoid repetition
  Map<String, int> eventCategoryCount = {}; // Track event types for better variety
  int eventChainDepth = 0; // Track how deep we are in event chains
  final Random _random = Random();
  
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
              _buildLifeStageSelection(),
              const SizedBox(height: 40),
              _buildLifeStageNextButton(),
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
                      'Life Simulation',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryWhite,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentStep == 0 
                          ? 'Step 1: Choose Life Stage' 
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
            'Navigate through Indian life\'s financial challenges and build wealth through smart decisions in expert-level scenarios.',
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

  Widget _buildLifeStageSelection() {
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
            'Choose Your Life Stage',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryBlack,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start your financial journey from any life stage. Each stage has unique challenges and opportunities.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          // Create a grid of life stages
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: LifeStage.values.length,
            itemBuilder: (context, index) {
              return _buildLifeStageOption(LifeStage.values[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLifeStageOption(LifeStage lifeStage) {
    final isSelected = selectedLifeStage == lifeStage;
    return GestureDetector(
      onTap: () => setState(() => selectedLifeStage = lifeStage),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlack : accentGray.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryBlack : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              lifeStage.icon,
              color: isSelected ? primaryWhite : lifeStage.color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              lifeStage.displayName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? primaryWhite : primaryBlack,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLifeStageNextButton() {
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
              ? 'Begin Your Expert Life Simulation Journey'
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

  // Placeholder implementations for missing methods
  Widget _buildGameHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryBlack,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${character!.name} - ${character!.currentStage.displayName}',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: primaryWhite,
        ),
        textAlign: TextAlign.center,
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
      ),
      child: Column(
        children: [
          _buildStatRow('Savings', '₹${character!.savings.toStringAsFixed(0)}', character!.savings / 5000000, Colors.green),
          _buildStatRow('Credit Score', '${character!.creditScore}', character!.creditScore / 850, Colors.blue),
          _buildStatRow('Happiness', '${character!.happiness}%', character!.happiness / 100, Colors.orange),
          _buildStatRow('Knowledge', '${character!.knowledge}%', character!.knowledge / 100, Colors.purple),
          _buildStatRow('Stress', '${character!.stress}%', character!.stress / 100, Colors.red),
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
              Expanded(
                flex: 2,
                child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  value, 
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentEvent!.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            currentEvent!.description,
            style: const TextStyle(fontSize: 16, height: 1.4),
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
          backgroundColor: primaryBlack,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              choice.text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryWhite,
              ),
            ),
            if (choice.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                choice.description,
                style: TextStyle(
                  fontSize: 14,
                  color: primaryWhite.withOpacity(0.8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        children: [
          const Text(
            'Outcome',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            lastChoiceOutcome,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                showingResult = false;
                currentEvent = null;
              });
              _nextEvent();
            },
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
        padding: const EdgeInsets.all(16),
      ),
      child: const Text(
        'Next Challenge',
        style: TextStyle(fontSize: 18, color: primaryWhite),
      ),
    );
  }

  Widget _buildAchievements() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: lightGray),
      ),
      child: const Column(
        children: [
          Text(
            'Achievements',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text('Achievement system coming soon...'),
        ],
      ),
    );
  }

  void _startGame() {
    if (characterName.trim().isEmpty) return;
    
    // Set character starting values based on selected life stage
    Map<String, dynamic> stageDefaults = _getLifeStageDefaults(selectedLifeStage);
    
    setState(() {
      character = FinancialCharacter(
        name: characterName.trim(),
        currentStage: selectedLifeStage,
        age: stageDefaults['age'],
        savings: stageDefaults['savings'],
        creditScore: stageDefaults['creditScore'],
        xp: 0,
        stress: stageDefaults['stress'],
        income: stageDefaults['income'],
        happiness: stageDefaults['happiness'],
        knowledge: stageDefaults['knowledge'],
      );
      gameStarted = true;
      completedEventIds.clear(); // Reset completed events for new game
      eventCategoryCount.clear(); // Reset category tracking
      eventChainDepth = 0; // Reset chain depth
      
      // Start the first event
      _nextEvent();
    });
  }

  Map<String, dynamic> _getLifeStageDefaults(LifeStage stage) {
    switch (stage) {
      case LifeStage.teen:
        return {
          'age': 16,
          'savings': 25000.0,
          'creditScore': 0, // No credit history yet
          'stress': 30,
          'income': 0.0,
          'happiness': 80,
          'knowledge': 20,
        };
      case LifeStage.college:
        return {
          'age': 19,
          'savings': 50000.0,
          'creditScore': 620, // Basic credit score
          'stress': 45,
          'income': 15000.0, // Part-time income
          'happiness': 75,
          'knowledge': 35,
        };
      case LifeStage.firstJob:
        return {
          'age': 23,
          'savings': 150000.0,
          'creditScore': 680,
          'stress': 55,
          'income': 600000.0, // Annual income
          'happiness': 70,
          'knowledge': 45,
        };
      case LifeStage.marriage:
        return {
          'age': 27,
          'savings': 800000.0,
          'creditScore': 720,
          'stress': 50,
          'income': 1200000.0,
          'happiness': 85,
          'knowledge': 55,
        };
      case LifeStage.homeOwner:
        return {
          'age': 30,
          'savings': 500000.0, // Lower due to home down payment
          'creditScore': 750,
          'stress': 60,
          'income': 1500000.0,
          'happiness': 80,
          'knowledge': 65,
        };
      case LifeStage.parenthood:
        return {
          'age': 32,
          'savings': 1200000.0,
          'creditScore': 760,
          'stress': 70,
          'income': 1800000.0,
          'happiness': 90,
          'knowledge': 70,
        };
      case LifeStage.careerPeak:
        return {
          'age': 40,
          'savings': 3500000.0,
          'creditScore': 800,
          'stress': 65,
          'income': 2500000.0,
          'happiness': 85,
          'knowledge': 80,
        };
      case LifeStage.preRetirement:
        return {
          'age': 55,
          'savings': 8000000.0,
          'creditScore': 820,
          'stress': 55,
          'income': 3000000.0,
          'happiness': 80,
          'knowledge': 90,
        };
      case LifeStage.retirement:
        return {
          'age': 60,
          'savings': 12000000.0,
          'creditScore': 800,
          'stress': 40,
          'income': 1200000.0, // Retirement income
          'happiness': 85,
          'knowledge': 95,
        };
    }
  }

  void _nextEvent() {
    if (character == null) return;

    // Generate a sophisticated, case-based event that hasn't been completed
    LifeEvent? nextEvent = _generateComplexCaseEvent();
    
    if (nextEvent != null) {
      setState(() {
        currentEvent = nextEvent;
        showingResult = false;
      });
    } else {
      // If no events available, show completion or generate a random crisis
      _generateCrisisEvent();
    }
  }

  LifeEvent? _generateComplexCaseEvent() {
    List<LifeEvent> availableEvents = [];
    
    // Generate different types of complex case-based events
    for (int i = 0; i < 5; i++) { // Try to generate 5 different events
      LifeEvent event = _generateRandomCaseEvent(i);
      if (!completedEventIds.contains(event.id)) {
        availableEvents.add(event);
      }
    }
    
    if (availableEvents.isEmpty) {
      return null;
    }
    
    // Select event with preference for underrepresented categories
    availableEvents.sort((a, b) {
      int aCount = eventCategoryCount[a.category] ?? 0;
      int bCount = eventCategoryCount[b.category] ?? 0;
      return aCount.compareTo(bCount);
    });
    
    return availableEvents.first;
  }

  LifeEvent _generateRandomCaseEvent(int seed) {
    // Use seed to generate different types of complex cases
    int eventType = (seed + character!.age + _random.nextInt(100)) % 4;
    
    switch (eventType) {
      case 0:
        return _generateEconomicCrisisEvent(seed);
      case 1:
        return _generateInvestmentDilemmaEvent(seed);
      case 2:
        return _generateFamilyFinancialCrisisEvent(seed);
      case 3:
        return _generateBusinessOpportunityEvent(seed);
      default:
        return _generateEconomicCrisisEvent(seed);
    }
  }

  void _generateCrisisEvent() {
    // Generate a final crisis event when regular events are exhausted
    LifeEvent crisisEvent = LifeEvent(
      id: 'crisis_final_${_random.nextInt(1000)}',
      title: 'The Ultimate Financial Test',
      description: 'Multiple financial challenges hit simultaneously. How do you navigate this perfect storm?',
      choices: [
        LifeChoice(
          text: 'Liquidate all investments for cash',
          description: 'Convert everything to cash for maximum liquidity',
          moneyImpact: character!.savings * 0.7, // 30% loss due to panic selling
          happinessImpact: -20,
          stressImpact: 40,
          knowledgeImpact: 10,
          creditScoreImpact: -50,
          outcomeText: 'You survived the crisis but lost significant wealth in panic selling.',
        ),
        LifeChoice(
          text: 'Hold positions and take strategic debt',
          description: 'Maintain investments and use debt for liquidity',
          moneyImpact: -character!.savings * 0.1,
          happinessImpact: 10,
          stressImpact: 60,
          knowledgeImpact: 25,
          creditScoreImpact: -20,
          outcomeText: 'Bold strategy! You preserved wealth but took on significant stress.',
        ),
      ],
      applicableStages: LifeStage.values,
      category: 'crisis',
    );
    
    setState(() {
      currentEvent = crisisEvent;
      showingResult = false;
    });
  }

  void _makeChoice(LifeChoice choice) {
    if (character == null || currentEvent == null) return;

    // Track this event as completed
    completedEventIds.add(currentEvent!.id);
    
    // Track event category for variety
    eventCategoryCount[currentEvent!.category] = 
        (eventCategoryCount[currentEvent!.category] ?? 0) + 1;

    // Apply choice effects with expert-level scaling (3x multiplier)
    final moneyImpact = choice.moneyImpact * 3.0;
    final newSavings = (character!.savings + moneyImpact).clamp(0.0, double.infinity);
    final newHappiness = (character!.happiness + choice.happinessImpact).clamp(0, 100);
    final newStress = (character!.stress + choice.stressImpact).clamp(0, 100);
    final newKnowledge = (character!.knowledge + choice.knowledgeImpact).clamp(0, 100);
    final newCreditScore = (character!.creditScore + choice.creditScoreImpact).clamp(300, 850);

    setState(() {
      character = character!.copyWith(
        savings: newSavings,
        happiness: newHappiness,
        stress: newStress,
        knowledge: newKnowledge,
        creditScore: newCreditScore,
      );
      
      lastChoiceOutcome = choice.outcomeText;
      showingResult = true;
      
      // Increase chain depth
      eventChainDepth++;
    });
  }

  // Complex case-based event generators
  LifeEvent _generateEconomicCrisisEvent(int seed) {
    final scenarios = [
      {
        'title': 'Market Crash & Recession',
        'description': 'Stock markets have crashed 40%, your mutual funds are down ₹8 lakhs, property prices falling, and layoffs are happening. Your monthly expenses are ₹80,000.',
        'choices': [
          {
            'text': 'Panic sell everything and keep cash',
            'description': 'Preserve remaining capital',
            'moneyImpact': -800000.0,
            'happinessImpact': -15,
            'stressImpact': 30,
            'knowledgeImpact': 5,
            'creditScoreImpact': -30,
            'outcomeText': 'You locked in massive losses. Markets recovered within 2 years, but you missed the rebound.',
          },
          {
            'text': 'Hold investments, reduce expenses drastically',
            'description': 'Ride out the storm',
            'moneyImpact': -200000.0,
            'happinessImpact': 5,
            'stressImpact': 40,
            'knowledgeImpact': 20,
            'creditScoreImpact': -10,
            'outcomeText': 'Tough 18 months but your investments recovered. You learned discipline but stress was enormous.',
          },
          {
            'text': 'Opportunistic buying with emergency fund',
            'description': 'Buy when others are fearful',
            'moneyImpact': 400000.0,
            'happinessImpact': 20,
            'stressImpact': 50,
            'knowledgeImpact': 30,
            'creditScoreImpact': 10,
            'outcomeText': 'Contrarian strategy paid off! You bought quality assets cheap and made significant gains.',
          },
        ]
      },
      {
        'title': 'Currency Devaluation Crisis',
        'description': 'Rupee has fallen 25% against USD in 3 months. Your NRI brother\'s dollar remittances are worth more, but imported goods are expensive.',
        'choices': [
          {
            'text': 'Convert all savings to USD',
            'description': 'Hedge against further rupee fall',
            'moneyImpact': 200000.0,
            'happinessImpact': 10,
            'stressImpact': 25,
            'knowledgeImpact': 20,
            'creditScoreImpact': 0,
            'outcomeText': 'Smart currency hedge! You preserved wealth as rupee fell further over next year.',
          },
          {
            'text': 'Invest in export-oriented Indian stocks',
            'description': 'Benefit from weak rupee',
            'moneyImpact': 300000.0,
            'happinessImpact': 15,
            'stressImpact': 20,
            'knowledgeImpact': 25,
            'creditScoreImpact': 5,
            'outcomeText': 'Export companies thrived with weak rupee. Your stock picks gained 60% in the year.',
          },
        ]
      }
    ];

    final scenario = scenarios[seed % scenarios.length];
    final scenarioChoices = scenario['choices'] as List;
    
    return LifeEvent(
      id: 'crisis_economic_${seed}_${_random.nextInt(1000)}',
      title: scenario['title'] as String,
      description: scenario['description'] as String,
      choices: scenarioChoices.map((choice) {
        final choiceMap = choice as Map<String, dynamic>;
        return LifeChoice(
          text: choiceMap['text'],
          description: choiceMap['description'],
          moneyImpact: choiceMap['moneyImpact'],
          happinessImpact: choiceMap['happinessImpact'],
          stressImpact: choiceMap['stressImpact'],
          knowledgeImpact: choiceMap['knowledgeImpact'],
          creditScoreImpact: choiceMap['creditScoreImpact'],
          outcomeText: choiceMap['outcomeText'],
        );
      }).toList(),
      applicableStages: LifeStage.values,
      category: 'economic_crisis',
    );
  }

  LifeEvent _generateInvestmentDilemmaEvent(int seed) {
    return LifeEvent(
      id: 'investment_dilemma_${seed}_${_random.nextInt(1000)}',
      title: 'Crypto Investment FOMO',
      description: 'Bitcoin has risen 300% this year. Your friend made ₹50 lakhs from ₹5 lakhs investment. You have ₹10 lakhs idle in savings account.',
      choices: [
        LifeChoice(
          text: 'Invest ₹8 lakhs in crypto',
          description: 'High risk, high reward',
          moneyImpact: -400000,
          happinessImpact: 20,
          stressImpact: 40,
          knowledgeImpact: 15,
          creditScoreImpact: -10,
          outcomeText: 'Extreme volatility followed. You made ₹12 lakhs but lost ₹8 lakhs twice. Net positive but stressful.',
        ),
        LifeChoice(
          text: 'Invest ₹2 lakhs as experiment',
          description: 'Limited exposure',
          moneyImpact: 100000,
          happinessImpact: 10,
          stressImpact: 20,
          knowledgeImpact: 20,
          creditScoreImpact: 0,
          outcomeText: 'Conservative approach paid off. Small gains without major stress or losses.',
        ),
        LifeChoice(
          text: 'Avoid crypto, focus on traditional assets',
          description: 'Stay with proven investments',
          moneyImpact: 50000,
          happinessImpact: 5,
          stressImpact: 5,
          knowledgeImpact: 15,
          creditScoreImpact: 10,
          outcomeText: 'You missed crypto gains but avoided massive volatility. Steady traditional portfolio growth.',
        ),
      ],
      applicableStages: LifeStage.values,
      category: 'investment',
    );
  }

  LifeEvent _generateFamilyFinancialCrisisEvent(int seed) {
    return LifeEvent(
      id: 'family_crisis_${seed}_${_random.nextInt(1000)}',
      title: 'Parent\'s Medical Emergency',
      description: 'Your father needs emergency heart surgery costing ₹12 lakhs. Insurance covers ₹6 lakhs. Your siblings can contribute ₹2 lakhs total.',
      choices: [
        LifeChoice(
          text: 'Liquidate all your investments',
          description: 'Family first approach',
          moneyImpact: -1200000,
          happinessImpact: 25,
          stressImpact: 30,
          knowledgeImpact: 10,
          creditScoreImpact: -20,
          outcomeText: 'Father recovered completely. Family gratitude was immense but your financial goals were delayed by 3 years.',
        ),
        LifeChoice(
          text: 'Take personal loan for ₹4 lakhs',
          description: 'Balanced financial approach',
          moneyImpact: -400000,
          happinessImpact: 20,
          stressImpact: 25,
          knowledgeImpact: 15,
          creditScoreImpact: -30,
          outcomeText: 'Surgery was successful. EMI burden for 3 years but you preserved most investments.',
        ),
        LifeChoice(
          text: 'Crowdfund and seek community help',
          description: 'Social support network',
          moneyImpact: -200000,
          happinessImpact: 15,
          stressImpact: 35,
          knowledgeImpact: 20,
          creditScoreImpact: 0,
          outcomeText: 'Community rallied to help. Emotionally overwhelming but financially manageable solution.',
        ),
      ],
      applicableStages: LifeStage.values,
      category: 'family_crisis',
    );
  }

  LifeEvent _generateBusinessOpportunityEvent(int seed) {
    return LifeEvent(
      id: 'business_opportunity_${seed}_${_random.nextInt(1000)}',
      title: 'Franchise Investment Opportunity',
      description: 'A popular coffee chain is offering franchise in your city for ₹25 lakhs. Expected ROI is 30% annually, but requires active management.',
      choices: [
        LifeChoice(
          text: 'Invest full amount and quit job',
          description: 'All-in entrepreneurial approach',
          moneyImpact: 750000,
          happinessImpact: 30,
          stressImpact: 40,
          knowledgeImpact: 35,
          creditScoreImpact: -20,
          outcomeText: 'Franchise was hugely successful! You became financially independent but initial 2 years were extremely stressful.',
        ),
        LifeChoice(
          text: 'Partner with friend (50-50)',
          description: 'Shared risk and responsibility',
          moneyImpact: 375000,
          happinessImpact: 20,
          stressImpact: 25,
          knowledgeImpact: 25,
          creditScoreImpact: -10,
          outcomeText: 'Partnership worked well. Shared stress and profits, but decision-making required constant coordination.',
        ),
        LifeChoice(
          text: 'Decline and stick to job',
          description: 'Risk-averse approach',
          moneyImpact: 0,
          happinessImpact: 5,
          stressImpact: 5,
          knowledgeImpact: 10,
          creditScoreImpact: 0,
          outcomeText: 'You chose safety. The franchise did well but you missed a significant wealth creation opportunity.',
        ),
      ],
      applicableStages: LifeStage.values,
      category: 'business',
    );
  }
}
