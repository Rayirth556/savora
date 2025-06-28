// lib/screens/life_simulator_game.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

class LifeEvent {
  final String title;
  final String description;
  final List<LifeChoice> choices;
  final int minAge;
  final int maxAge;

  LifeEvent({
    required this.title,
    required this.description,
    required this.choices,
    required this.minAge,
    required this.maxAge,
  });
}

class LifeChoice {
  final String text;
  final int moneyImpact;
  final int happinessImpact;
  final String consequence;
  final Map<String, dynamic> effects;

  LifeChoice({
    required this.text,
    required this.moneyImpact,
    required this.happinessImpact,
    required this.consequence,
    this.effects = const {},
  });
}

class GameCharacter {
  int age;
  int money;
  int happiness;
  int education;
  String job;
  bool hasHouse;
  bool hasPartner;
  List<String> achievements;
  Map<String, dynamic> stats;

  GameCharacter({
    this.age = 18,
    this.money = 1000,
    this.happiness = 70,
    this.education = 50,
    this.job = 'Student',
    this.hasHouse = false,
    this.hasPartner = false,
    this.achievements = const [],
    this.stats = const {},
  });
}

class LifeSimulatorGame extends StatefulWidget {
  const LifeSimulatorGame({super.key});

  @override
  State<LifeSimulatorGame> createState() => _LifeSimulatorGameState();
}

class _LifeSimulatorGameState extends State<LifeSimulatorGame>
    with TickerProviderStateMixin {
  late GameCharacter character;
  late AnimationController _ageAnimationController;
  late AnimationController _moneyAnimationController;
  late AnimationController _happinessAnimationController;
  late AnimationController _backgroundAnimationController;
  late Animation<double> _ageAnimation;
  late Animation<double> _moneyAnimation;
  late Animation<double> _happinessAnimation;
  late Animation<Color?> _backgroundColorAnimation;
  
  List<LifeEvent> currentEvents = [];
  LifeEvent? activeEvent;
  bool gameEnded = false;
  bool _showingResult = false;
  
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    character = GameCharacter();
    
    // Initialize animation controllers
    _ageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _moneyAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _happinessAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    // Initialize animations
    _ageAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ageAnimationController, curve: Curves.elasticOut),
    );
    _moneyAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _moneyAnimationController, curve: Curves.bounceOut),
    );
    _happinessAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _happinessAnimationController, curve: Curves.easeInOut),
    );
    _backgroundColorAnimation = ColorTween(
      begin: Colors.purple.withOpacity(0.1),
      end: Colors.blue.withOpacity(0.2),
    ).animate(_backgroundAnimationController);
    
    _generateNextEvent();
  }

  @override
  void dispose() {
    _ageAnimationController.dispose();
    _moneyAnimationController.dispose();
    _happinessAnimationController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  void _generateNextEvent() {
    final availableEvents = _getEventsForAge(character.age);
    if (availableEvents.isNotEmpty) {
      setState(() {
        activeEvent = availableEvents[random.nextInt(availableEvents.length)];
      });
    } else {
      _endGame();
    }
  }

  List<LifeEvent> _getEventsForAge(int age) {
    return [
      // College Years (18-22)
      if (age >= 18 && age <= 22)
        LifeEvent(
          title: "College Decision",
          description: "You're 18 and need to decide about your education future.",
          minAge: 18,
          maxAge: 22,
          choices: [
            LifeChoice(
              text: "Go to expensive private college (\$200k debt)",
              moneyImpact: -200000,
              happinessImpact: 20,
              consequence: "You graduate with a prestigious degree but heavy debt.",
              effects: {'education': 40, 'debt': 200000},
            ),
            LifeChoice(
              text: "Choose affordable state college (\$50k debt)",
              moneyImpact: -50000,
              happinessImpact: 10,
              consequence: "You get a solid education with manageable debt.",
              effects: {'education': 25, 'debt': 50000},
            ),
            LifeChoice(
              text: "Skip college and start working",
              moneyImpact: 30000,
              happinessImpact: -10,
              consequence: "You start earning immediately but limit future opportunities.",
              effects: {'job': 'Entry Level Worker'},
            ),
            LifeChoice(
              text: "Community college + transfer (Smart choice!)",
              moneyImpact: -20000,
              happinessImpact: 15,
              consequence: "You save money and still get a great education!",
              effects: {'education': 30, 'debt': 20000, 'smartChoice': true},
            ),
          ],
        ),

      // Early Career (23-30)
      if (age >= 23 && age <= 30)
        LifeEvent(
          title: "First Job Offer",
          description: "You've graduated and received job offers. Choose wisely!",
          minAge: 23,
          maxAge: 30,
          choices: [
            LifeChoice(
              text: "High-paying corporate job (\$80k/year, long hours)",
              moneyImpact: 80000,
              happinessImpact: -5,
              consequence: "Good money but work-life balance suffers.",
              effects: {'job': 'Corporate Employee', 'stress': 20},
            ),
            LifeChoice(
              text: "Non-profit job (\$45k/year, meaningful work)",
              moneyImpact: 45000,
              happinessImpact: 15,
              consequence: "Lower pay but you love what you do!",
              effects: {'job': 'Non-profit Worker', 'fulfillment': 30},
            ),
            LifeChoice(
              text: "Start your own business (risky but potential!)",
              moneyImpact: random.nextBool() ? 100000 : -20000,
              happinessImpact: random.nextBool() ? 25 : -15,
              consequence: "Entrepreneurship is a rollercoaster ride!",
              effects: {'job': 'Entrepreneur', 'risk_taker': true},
            ),
          ],
        ),

      // Housing Decision (25-35)
      if (age >= 25 && age <= 35 && !character.hasHouse)
        LifeEvent(
          title: "Housing Dilemma",
          description: "You need somewhere to live. What's your strategy?",
          minAge: 25,
          maxAge: 35,
          choices: [
            LifeChoice(
              text: "Buy a house with 5% down payment",
              moneyImpact: -15000,
              happinessImpact: 20,
              consequence: "You're a homeowner but have a large mortgage!",
              effects: {'hasHouse': true, 'mortgage': 200000},
            ),
            LifeChoice(
              text: "Rent and invest the difference",
              moneyImpact: -12000,
              happinessImpact: 5,
              consequence: "You maintain flexibility and invest wisely.",
              effects: {'investments': 50000},
            ),
            LifeChoice(
              text: "Live with roommates to save money",
              moneyImpact: -6000,
              happinessImpact: -5,
              consequence: "Less privacy but more savings!",
              effects: {'savings': 30000},
            ),
          ],
        ),

      // Investment Opportunity (30-50)
      if (age >= 30 && age <= 50)
        LifeEvent(
          title: "Investment Opportunity",
          description: "A friend offers you an investment opportunity. What do you do?",
          minAge: 30,
          maxAge: 50,
          choices: [
            LifeChoice(
              text: "Invest \$10k in their 'guaranteed' scheme",
              moneyImpact: random.nextBool() ? 50000 : -10000,
              happinessImpact: random.nextBool() ? 15 : -20,
              consequence: "High risk, high reward... or total loss!",
              effects: {'risky_investment': true},
            ),
            LifeChoice(
              text: "Put money in index funds instead",
              moneyImpact: 25000,
              happinessImpact: 10,
              consequence: "Slow and steady wins the race!",
              effects: {'wise_investor': true},
            ),
            LifeChoice(
              text: "Keep money in savings account",
              moneyImpact: 1000,
              happinessImpact: 0,
              consequence: "Safe but inflation eats your purchasing power.",
              effects: {'conservative': true},
            ),
          ],
        ),

      // Mid-life Crisis (40-50)
      if (age >= 40 && age <= 50)
        LifeEvent(
          title: "Mid-life Reflection",
          description: "You're questioning your life choices. What's your move?",
          minAge: 40,
          maxAge: 50,
          choices: [
            LifeChoice(
              text: "Buy an expensive sports car (\$80k)",
              moneyImpact: -80000,
              happinessImpact: 15,
              consequence: "You feel young again... until the payments hit.",
              effects: {'midlife_crisis': true},
            ),
            LifeChoice(
              text: "Go back to school for a career change",
              moneyImpact: -30000,
              happinessImpact: 20,
              consequence: "Investment in yourself pays off long-term!",
              effects: {'education': 20, 'career_change': true},
            ),
            LifeChoice(
              text: "Focus on family and experiences",
              moneyImpact: -5000,
              happinessImpact: 25,
              consequence: "Money can't buy happiness, but experiences can!",
              effects: {'family_focused': true},
            ),
          ],
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Life Simulator', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.withOpacity(0.8), Colors.blue.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: _backgroundColorAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _backgroundColorAnimation.value ?? Colors.purple.withOpacity(0.1),
                  Colors.white,
                  Colors.blue.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: gameEnded ? _buildGameEndScreen() : _buildGameScreen(),
          );
        },
      ),
    );
  }

  Widget _buildGameScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
      child: Column(
        children: [
          _buildCharacterStats(),
          const SizedBox(height: 20),
          if (activeEvent != null && !_showingResult) _buildEventCard(),
          if (_showingResult) _buildResultCard(),
        ],
      ),
    );
  }

  Widget _buildCharacterStats() {
    return AnimatedBuilder(
      animation: Listenable.merge([_ageAnimation, _moneyAnimation, _happinessAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: 0.95 + (_ageAnimation.value * 0.05),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.blue.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildCharacterAvatar(),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedDefaultTextStyle(
                                  style: TextStyle(
                                    fontSize: 24 + (_ageAnimation.value * 4),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple.shade800,
                                  ),
                                  duration: const Duration(milliseconds: 500),
                                  child: Text('Age: ${character.age}'),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Job: ${character.job}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                AnimatedDefaultTextStyle(
                                  style: TextStyle(
                                    fontSize: 18 + (_moneyAnimation.value * 2),
                                    fontWeight: FontWeight.bold,
                                    color: character.money >= 0 ? Colors.green.shade700 : Colors.red.shade700,
                                  ),
                                  duration: const Duration(milliseconds: 500),
                                  child: Text('Money: \$${_formatMoney(character.money)}'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildAnimatedProgressBar('Happiness', character.happiness, 100, 
                        [Colors.orange.shade300, Colors.orange.shade600], Icons.sentiment_very_satisfied),
                      const SizedBox(height: 12),
                      _buildAnimatedProgressBar('Education', character.education, 100, 
                        [Colors.blue.shade300, Colors.blue.shade600], Icons.school),
                      if (character.hasHouse) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.green.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.home, color: Colors.green.shade700, size: 16),
                              const SizedBox(width: 4),
                              Text('Homeowner', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCharacterAvatar() {
    IconData icon;
    List<Color> colors;
    
    if (character.age < 25) {
      icon = Icons.school;
      colors = [Colors.green.shade300, Colors.green.shade600];
    } else if (character.age < 40) {
      icon = Icons.work;
      colors = [Colors.blue.shade300, Colors.blue.shade600];
    } else if (character.age < 60) {
      icon = Icons.family_restroom;
      colors = [Colors.purple.shade300, Colors.purple.shade600];
    } else {
      icon = Icons.elderly;
      colors = [Colors.grey.shade400, Colors.grey.shade600];
    }

    return AnimatedBuilder(
      animation: _ageAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (sin(_ageAnimationController.value * 2 * pi) * 0.05),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors[1].withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(icon, size: 40, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedProgressBar(String label, int value, int max, List<Color> colors, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: colors[1]),
                const SizedBox(width: 6),
                Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: colors[1])),
              ],
            ),
            Text('$value/$max', style: TextStyle(fontWeight: FontWeight.bold, color: colors[1])),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey.shade200,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AnimatedBuilder(
              animation: _happinessAnimationController,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: value / max,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.lerp(colors[0], colors[1], 
                      0.5 + 0.5 * sin(_happinessAnimationController.value * 2 * pi)) ?? colors[1],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.95),
                    Colors.purple.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.2),
                    blurRadius: 25,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.purple.shade300, Colors.purple.shade600],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.event, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                activeEvent!.title,
                                style: const TextStyle(
                                  fontSize: 22, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Text(
                            activeEvent!.description,
                            style: const TextStyle(fontSize: 16, height: 1.4),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...activeEvent!.choices.asMap().entries.map((entry) {
                          final index = entry.key;
                          final choice = entry.value;
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: Duration(milliseconds: 400 + (index * 100)),
                            curve: Curves.easeOutBack,
                            builder: (context, animValue, child) {
                              return Transform.translate(
                                offset: Offset(100 * (1 - animValue), 0),
                                child: Opacity(
                                  opacity: animValue.clamp(0.0, 1.0),
                                  child: _buildChoiceButton(choice),
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChoiceButton(LifeChoice choice) {
    Color primaryColor = Colors.blue;
    if (choice.moneyImpact > 0) primaryColor = Colors.green;
    if (choice.moneyImpact < -50000) primaryColor = Colors.red;
    if (choice.happinessImpact > 15) primaryColor = Colors.orange;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _makeChoice(choice),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.1),
                  primaryColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryColor.withOpacity(0.3), width: 2),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  choice.text,
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    color: primaryColor.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    if (choice.moneyImpact != 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: choice.moneyImpact > 0 
                              ? [Colors.green.shade400, Colors.green.shade600]
                              : [Colors.red.shade400, Colors.red.shade600],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: (choice.moneyImpact > 0 ? Colors.green : Colors.red).withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              choice.moneyImpact > 0 ? Icons.trending_up : Icons.trending_down,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${choice.moneyImpact > 0 ? '+' : ''}\$${_formatMoney(choice.moneyImpact)}',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    if (choice.happinessImpact != 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: choice.happinessImpact > 0 
                              ? [Colors.orange.shade400, Colors.orange.shade600]
                              : [Colors.grey.shade400, Colors.grey.shade600],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: (choice.happinessImpact > 0 ? Colors.orange : Colors.grey).withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              choice.happinessImpact > 0 ? Icons.sentiment_very_satisfied : Icons.sentiment_dissatisfied,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${choice.happinessImpact > 0 ? '+' : ''}${choice.happinessImpact}',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameEndScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber.shade300, Colors.amber.shade600],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.flag, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Life Complete!',
                    style: TextStyle(
                      fontSize: 32, 
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.9),
                          Colors.amber.withOpacity(0.1),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildStatRow('Final Age', '${character.age}', Icons.cake, Colors.purple),
                        const SizedBox(height: 16),
                        _buildStatRow('Net Worth', '\$${_formatMoney(character.money)}', 
                          Icons.account_balance_wallet, character.money >= 0 ? Colors.green : Colors.red),
                        const SizedBox(height: 16),
                        _buildStatRow('Happiness', '${character.happiness}/100', 
                          Icons.sentiment_very_satisfied, Colors.orange),
                        const SizedBox(height: 16),
                        _buildStatRow('Life Rating', _getLifeRating(), Icons.star, Colors.amber),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade600],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _resetGame,
                        borderRadius: BorderRadius.circular(16),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.refresh, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Start New Life',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
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
    );
  }

  Widget _buildResultCard() {
    if (activeEvent == null) return const SizedBox.shrink();
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.bounceOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.green.withOpacity(0.1),
                  Colors.blue.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade600],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Choice Made!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Processing your life decision...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _makeChoice(LifeChoice choice) {
    setState(() {
      _showingResult = true;
    });

    // Start animations
    _ageAnimationController.forward();
    _moneyAnimationController.forward();
    _happinessAnimationController.forward();

    // Apply changes after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        character.money += choice.moneyImpact;
        character.happiness = (character.happiness + choice.happinessImpact).clamp(0, 100);
        character.age += random.nextInt(3) + 1; // Age 1-3 years
        
        // Apply effects
        choice.effects.forEach((key, value) {
          switch (key) {
            case 'education':
              character.education = (character.education + value as int).clamp(0, 100);
              break;
            case 'job':
              character.job = value;
              break;
            case 'hasHouse':
              character.hasHouse = value;
              break;
          }
        });
      });

      _showChoiceResult(choice);
    });
  }

  void _showChoiceResult(LifeChoice choice) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: const EdgeInsets.all(24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade600],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lightbulb, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Consequence',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    choice.consequence,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade600],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          _continueGame();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          child: Text(
                            'Continue',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _continueGame() {
    setState(() {
      _showingResult = false;
    });

    // Reset animations
    _ageAnimationController.reset();
    _moneyAnimationController.reset();
    _happinessAnimationController.reset();
    
    if (character.age >= 80) {
      _endGame();
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        _generateNextEvent();
      });
    }
  }

  void _endGame() {
    setState(() {
      gameEnded = true;
    });
  }

  void _resetGame() {
    setState(() {
      character = GameCharacter();
      gameEnded = false;
      _showingResult = false;
    });
    
    // Reset all animations
    _ageAnimationController.reset();
    _moneyAnimationController.reset();
    _happinessAnimationController.reset();
    
    _generateNextEvent();
  }

  String _formatMoney(int amount) {
    if (amount.abs() >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount.abs() >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toString();
  }

  String _getLifeRating() {
    final score = (character.money / 1000000) + (character.happiness / 100);
    if (score >= 2) return 'Legendary Life! 🏆';
    if (score >= 1.5) return 'Great Life! 🌟';
    if (score >= 1) return 'Good Life! 👍';
    if (score >= 0.5) return 'Average Life 😐';
    return 'Challenging Life 😔';
  }
}
