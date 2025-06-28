// Enhanced Financial Survival Quest with White/Black Theme
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

  // Get current life stage progression
  double get stageProgress {
    switch (currentStage) {
      case LifeStage.teen:
        return (age - 15) / 3.0; // 15-18
      case LifeStage.college:
        return (age - 18) / 4.0; // 18-22
      case LifeStage.firstJob:
        return (age - 22) / 3.0; // 22-25
      case LifeStage.marriage:
        return (age - 25) / 5.0; // 25-30
      case LifeStage.homeOwner:
        return (age - 30) / 5.0; // 30-35
      case LifeStage.parenthood:
        return (age - 35) / 10.0; // 35-45
      case LifeStage.careerPeak:
        return (age - 45) / 10.0; // 45-55
      case LifeStage.preRetirement:
        return (age - 55) / 10.0; // 55-65
      case LifeStage.retirement:
        return (age - 65) / 20.0; // 65+
    }
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
      id: 'savings_1m',
      title: 'Millionaire',
      description: 'Reach \$1,000,000 in savings',
      icon: Icons.emoji_events,
      color: Colors.amber,
      requiredValue: 1000000,
      category: 'savings',
    ),
    
    // Credit Score Achievements
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
    
    // Knowledge Achievements
    Achievement(
      id: 'knowledge_50',
      title: 'Finance Student',
      description: 'Reach 50 knowledge points',
      icon: Icons.school,
      color: Colors.indigo,
      requiredValue: 50,
      category: 'knowledge',
    ),
    Achievement(
      id: 'knowledge_100',
      title: 'Finance Expert',
      description: 'Reach 100 knowledge points',
      icon: Icons.psychology,
      color: Colors.deepPurple,
      requiredValue: 100,
      category: 'knowledge',
    ),
  ];
}

// Game Event Data with difficulty-based scenarios
class GameEventData {
  static List<LifeEvent> getEventsForStage(LifeStage stage, GameDifficulty difficulty) {
    switch (stage) {
      case LifeStage.teen:
        return _getTeenEvents(difficulty);
      case LifeStage.college:
        return _getCollegeEvents(difficulty);
      case LifeStage.firstJob:
        return _getFirstJobEvents(difficulty);
      case LifeStage.marriage:
        return _getMarriageEvents(difficulty);
      case LifeStage.homeOwner:
        return _getHomeOwnerEvents(difficulty);
      case LifeStage.parenthood:
        return _getParenthoodEvents(difficulty);
      case LifeStage.careerPeak:
        return _getCareerPeakEvents(difficulty);
      case LifeStage.preRetirement:
        return _getPreRetirementEvents(difficulty);
      case LifeStage.retirement:
        return _getRetirementEvents(difficulty);
    }
  }

  static List<LifeEvent> _getTeenEvents(GameDifficulty difficulty) {
    final baseEvents = [
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
          LifeChoice(
            text: 'Invest in learning resources',
            description: 'Buy books or courses to improve skills',
            moneyImpact: -50 * difficulty.multiplier,
            happinessImpact: 10,
            stressImpact: 0,
            knowledgeImpact: 20,
            creditScoreImpact: 0,
            outcomeText: 'Excellent investment in yourself! Knowledge pays the best dividends.',
          ),
        ],
      ),
    ];
    
    if (difficulty == GameDifficulty.hard || difficulty == GameDifficulty.expert) {
      baseEvents.add(
        LifeEvent(
          id: 'teen_family_crisis',
          title: 'Family Financial Crisis',
          description: 'Your family faces unexpected financial hardship. They need your help.',
          applicableStages: [LifeStage.teen],
          difficulty: difficulty,
          category: 'crisis',
          choices: [
            LifeChoice(
              text: 'Give all savings to family',
              description: 'Help family but lose your savings',
              moneyImpact: -500 * difficulty.multiplier,
              happinessImpact: 20,
              stressImpact: 15,
              knowledgeImpact: 5,
              creditScoreImpact: 0,
              outcomeText: 'Your family is grateful, but you sacrificed your financial future.',
            ),
            LifeChoice(
              text: 'Help partially, keep emergency fund',
              description: 'Balance family support with financial security',
              moneyImpact: -200 * difficulty.multiplier,
              happinessImpact: 10,
              stressImpact: 5,
              knowledgeImpact: 15,
              creditScoreImpact: 0,
              outcomeText: 'Wise choice - you helped family while maintaining financial discipline.',
            ),
          ],
        ),
      );
    }
    
    return baseEvents;
  }

  static List<LifeEvent> _getCollegeEvents(GameDifficulty difficulty) {
    return [
      LifeEvent(
        id: 'college_tuition',
        title: 'College Funding Decision',
        description: 'Time to pay for college. How will you handle the costs?',
        applicableStages: [LifeStage.college],
        difficulty: difficulty,
        category: 'education',
        choices: [
          LifeChoice(
            text: 'Take student loans',
            description: 'Borrow money to pay for education',
            moneyImpact: -20000 * difficulty.multiplier,
            happinessImpact: 10,
            stressImpact: 20,
            knowledgeImpact: 25,
            creditScoreImpact: difficulty == GameDifficulty.easy ? 10 : -10,
            outcomeText: 'Education is an investment, but debt will follow you for years.',
          ),
          LifeChoice(
            text: 'Work part-time + scholarships',
            description: 'Balance work and studies to minimize debt',
            moneyImpact: -5000 * difficulty.multiplier,
            happinessImpact: 5,
            stressImpact: 15,
            knowledgeImpact: 30,
            creditScoreImpact: 5,
            outcomeText: 'Hard work pays off! You minimized debt while gaining experience.',
          ),
          LifeChoice(
            text: 'Community college first',
            description: 'Start cheaper, transfer later',
            moneyImpact: -2000 * difficulty.multiplier,
            happinessImpact: 0,
            stressImpact: 5,
            knowledgeImpact: 20,
            creditScoreImpact: 0,
            outcomeText: 'Smart financial move! You saved money on your education path.',
          ),
        ],
      ),
    ];
  }

  static List<LifeEvent> _getFirstJobEvents(GameDifficulty difficulty) {
    return [
      LifeEvent(
        id: 'first_salary',
        title: 'First Real Salary',
        description: 'You landed your first full-time job! How will you manage your new income?',
        applicableStages: [LifeStage.firstJob],
        difficulty: difficulty,
        category: 'career',
        choices: [
          LifeChoice(
            text: 'Live below means, save 20%',
            description: 'Maintain modest lifestyle, prioritize savings',
            moneyImpact: 5000 * difficulty.multiplier,
            happinessImpact: 5,
            stressImpact: -10,
            knowledgeImpact: 15,
            creditScoreImpact: 10,
            outcomeText: 'Excellent discipline! Your future self will thank you.',
          ),
          LifeChoice(
            text: 'Lifestyle inflation - nice apartment',
            description: 'Upgrade your lifestyle to match your income',
            moneyImpact: -1000 * difficulty.multiplier,
            happinessImpact: 15,
            stressImpact: 5,
            knowledgeImpact: -5,
            creditScoreImpact: 0,
            outcomeText: 'You enjoy better living, but savings growth is slower.',
          ),
          LifeChoice(
            text: 'Start retirement investing',
            description: 'Begin 401k and investment planning',
            moneyImpact: 2000 * difficulty.multiplier,
            happinessImpact: 10,
            stressImpact: -5,
            knowledgeImpact: 25,
            creditScoreImpact: 5,
            outcomeText: 'Brilliant! Starting early gives compound interest decades to work.',
          ),
        ],
      ),
    ];
  }

  static List<LifeEvent> _getMarriageEvents(GameDifficulty difficulty) {
    return [
      LifeEvent(
        id: 'wedding_planning',
        title: 'Wedding Planning',
        description: 'Planning your wedding. How much will you spend on this special day?',
        applicableStages: [LifeStage.marriage],
        difficulty: difficulty,
        category: 'life_events',
        choices: [
          LifeChoice(
            text: 'Modest wedding, save money',
            description: 'Simple ceremony, focus on marriage not wedding',
            moneyImpact: 15000 * difficulty.multiplier,
            happinessImpact: 10,
            stressImpact: -5,
            knowledgeImpact: 10,
            creditScoreImpact: 0,
            outcomeText: 'Wise priorities! You started married life with financial stability.',
          ),
          LifeChoice(
            text: 'Dream wedding, take loans',
            description: 'Perfect wedding day, worry about costs later',
            moneyImpact: -25000 * difficulty.multiplier,
            happinessImpact: 25,
            stressImpact: 20,
            knowledgeImpact: -10,
            creditScoreImpact: -15,
            outcomeText: 'Beautiful wedding, but debt stress affects your new marriage.',
          ),
        ],
      ),
    ];
  }

  static List<LifeEvent> _getHomeOwnerEvents(GameDifficulty difficulty) {
    return [
      LifeEvent(
        id: 'house_buying',
        title: 'Buying Your First Home',
        description: 'Ready to buy a house! What\'s your strategy?',
        applicableStages: [LifeStage.homeOwner],
        difficulty: difficulty,
        category: 'real_estate',
        choices: [
          LifeChoice(
            text: '20% down payment',
            description: 'Save up for proper down payment',
            moneyImpact: 10000 * difficulty.multiplier,
            happinessImpact: 15,
            stressImpact: -10,
            knowledgeImpact: 20,
            creditScoreImpact: 15,
            outcomeText: 'Excellent! No PMI and better mortgage terms save you thousands.',
          ),
          LifeChoice(
            text: 'Buy with 5% down',
            description: 'Buy sooner with minimal down payment',
            moneyImpact: -5000 * difficulty.multiplier,
            happinessImpact: 10,
            stressImpact: 10,
            knowledgeImpact: 5,
            creditScoreImpact: 5,
            outcomeText: 'You\'re a homeowner, but PMI and higher payments increase costs.',
          ),
        ],
      ),
    ];
  }

  static List<LifeEvent> _getParenthoodEvents(GameDifficulty difficulty) {
    return [
      LifeEvent(
        id: 'child_education',
        title: 'Child\'s Education Planning',
        description: 'Your child will need college funding. How do you prepare?',
        applicableStages: [LifeStage.parenthood],
        difficulty: difficulty,
        category: 'family',
        choices: [
          LifeChoice(
            text: 'Start 529 education savings',
            description: 'Begin systematic college savings plan',
            moneyImpact: 500 * difficulty.multiplier,
            happinessImpact: 15,
            stressImpact: -5,
            knowledgeImpact: 20,
            creditScoreImpact: 0,
            outcomeText: 'Great planning! Compound growth will help fund their education.',
          ),
          LifeChoice(
            text: 'They can get loans later',
            description: 'Focus on current needs, handle college costs later',
            moneyImpact: 2000 * difficulty.multiplier,
            happinessImpact: 5,
            stressImpact: 5,
            knowledgeImpact: -10,
            creditScoreImpact: 0,
            outcomeText: 'More immediate cash, but your child may face significant debt.',
          ),
        ],
      ),
    ];
  }

  static List<LifeEvent> _getCareerPeakEvents(GameDifficulty difficulty) {
    return [
      LifeEvent(
        id: 'career_opportunity',
        title: 'Major Career Opportunity',
        description: 'You\'re offered a high-paying position that requires relocation.',
        applicableStages: [LifeStage.careerPeak],
        difficulty: difficulty,
        category: 'career',
        choices: [
          LifeChoice(
            text: 'Take the promotion',
            description: 'Accept higher salary and new challenges',
            moneyImpact: 15000 * difficulty.multiplier,
            happinessImpact: 20,
            stressImpact: 15,
            knowledgeImpact: 25,
            creditScoreImpact: 5,
            outcomeText: 'Career advancement pays off! Higher income accelerates your goals.',
          ),
          LifeChoice(
            text: 'Stay for work-life balance',
            description: 'Prioritize family and current lifestyle',
            moneyImpact: 3000 * difficulty.multiplier,
            happinessImpact: 15,
            stressImpact: -5,
            knowledgeImpact: 5,
            creditScoreImpact: 0,
            outcomeText: 'Family stability has value beyond money.',
          ),
        ],
      ),
    ];
  }

  static List<LifeEvent> _getPreRetirementEvents(GameDifficulty difficulty) {
    return [
      LifeEvent(
        id: 'retirement_planning',
        title: 'Retirement Planning Check',
        description: 'Reviewing your retirement savings. Are you on track?',
        applicableStages: [LifeStage.preRetirement],
        difficulty: difficulty,
        category: 'retirement',
        choices: [
          LifeChoice(
            text: 'Increase retirement contributions',
            description: 'Maximize catch-up contributions',
            moneyImpact: 8000 * difficulty.multiplier,
            happinessImpact: 10,
            stressImpact: -15,
            knowledgeImpact: 15,
            creditScoreImpact: 0,
            outcomeText: 'Smart move! Every extra dollar now multiplies for retirement.',
          ),
          LifeChoice(
            text: 'Maintain current savings rate',
            description: 'Continue with existing plan',
            moneyImpact: 2000 * difficulty.multiplier,
            happinessImpact: 5,
            stressImpact: 5,
            knowledgeImpact: 0,
            creditScoreImpact: 0,
            outcomeText: 'Steady progress, but you might need to work longer.',
          ),
        ],
      ),
    ];
  }

  static List<LifeEvent> _getRetirementEvents(GameDifficulty difficulty) {
    return [
      LifeEvent(
        id: 'retirement_lifestyle',
        title: 'Retirement Lifestyle Choice',
        description: 'How will you spend your retirement years?',
        applicableStages: [LifeStage.retirement],
        difficulty: difficulty,
        category: 'retirement',
        choices: [
          LifeChoice(
            text: 'Conservative spending',
            description: 'Live modestly to preserve wealth',
            moneyImpact: 5000 * difficulty.multiplier,
            happinessImpact: 10,
            stressImpact: -10,
            knowledgeImpact: 5,
            creditScoreImpact: 0,
            outcomeText: 'Wise approach! Your money will last throughout retirement.',
          ),
          LifeChoice(
            text: 'Enjoy your wealth',
            description: 'You earned it, now spend it!',
            moneyImpact: -3000 * difficulty.multiplier,
            happinessImpact: 25,
            stressImpact: 5,
            knowledgeImpact: 0,
            creditScoreImpact: 0,
            outcomeText: 'Life is for living! You\'re enjoying your golden years.',
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
  String characterName = ''; // Add character name state
  int currentStep = 0; // 0: difficulty, 1: character creation
  
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
                onPressed: currentStep > 0 ? () => setState(() => currentStep--) : () => Navigator.pop(context),
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
                      currentStep == 0 ? 'Step 1: Choose Difficulty' : 'Step 2: Create Character',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFB0B0B0),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48), // Balance the back button
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
                    color: currentStep >= 1 ? primaryWhite : primaryWhite.withOpacity(0.3),
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
          ...GameDifficulty.values.map((difficulty) => _buildDifficultyOption(difficulty)),
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
                      color: isSelected ? primaryWhite.withOpacity(0.8) : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? primaryWhite.withOpacity(0.2) : Colors.grey[200],
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
        onPressed: _goToCharacterCreation,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Continue to Character Creation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryWhite,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, color: primaryWhite),
          ],
        ),
      ),
    );
  }

  void _goToCharacterCreation() {
    setState(() {
      currentStep = 1;
    });
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
    
    return Column(
      children: [
        _buildGameHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildCharacterStats(),
                const SizedBox(height: 20),
                if (currentEvent != null) ...[
                  _buildEventCard(),
                  const SizedBox(height: 20),
                ],
                if (showingResult) _buildResultCard(),
                _buildAchievements(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: primaryBlack,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryWhite,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      character!.currentStage.icon,
                      color: character!.currentStage.color,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${character!.currentStage.displayName} • Age ${character!.age}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFB0B0B0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryBlack,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: lightGray,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: lightGray),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryBlack,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.event, color: primaryWhite, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  currentEvent!.title,
                  style: const TextStyle(
                    fontSize: 22,
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
              color: Colors.grey[50],
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
      width: double.infinity,
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
          elevation: 0,
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
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildImpactChip('Money', choice.moneyImpact, Colors.green),
                _buildImpactChip('Happiness', choice.happinessImpact.toDouble(), Colors.orange),
                _buildImpactChip('Knowledge', choice.knowledgeImpact.toDouble(), Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactChip(String label, double impact, Color color) {
    if (impact == 0) return const SizedBox();
    
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '${impact > 0 ? '+' : ''}${impact.toStringAsFixed(0)} $label',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryBlack,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.lightbulb,
            color: primaryWhite,
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'Choice Result',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryWhite,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            lastChoiceOutcome,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFB0B0B0),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _continueGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryWhite,
              foregroundColor: primaryBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
          const Text(
            'Recent Achievements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryBlack,
            ),
          ),
          const SizedBox(height: 12),
          ...recentAchievements.take(3).map((achievement) => 
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: achievement.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: achievement.color.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(achievement.icon, color: achievement.color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          achievement.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: primaryBlack,
                          ),
                        ),
                        Text(
                          achievement.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
    });
    _generateNextEvent();
  }

  void _generateNextEvent() {
    final availableEvents = GameEventData.getEventsForStage(
      character!.currentStage,
      selectedDifficulty,
    );
    
    if (availableEvents.isNotEmpty) {
      setState(() {
        currentEvent = availableEvents[Random().nextInt(availableEvents.length)];
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
    
    // Check for achievements
    final newAchievements = <Achievement>[];
    for (final achievement in AchievementData.allAchievements) {
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
      final nextStage = character!.nextStage;
      if (nextStage != null && _shouldProgressStage()) {
        character = character!.copyWith(currentStage: nextStage);
      }
      
      lastChoiceOutcome = choice.outcomeText;
      showingResult = true;
      currentEvent = null;
    });
  }

  bool _shouldProgressStage() {
    // Progress based on age thresholds
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
        return false;
    }
  }

  void _continueGame() {
    _generateNextEvent();
  }
}
