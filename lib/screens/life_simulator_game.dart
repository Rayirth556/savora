// lib/screens/life_simulator_game.dart
import 'package:flutter/material.dart';
import 'dart:math';

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
  
  List<LifeEvent> currentEvents = [];
  LifeEvent? activeEvent;
  bool gameEnded = false;
  
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    character = GameCharacter();
    _ageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _moneyAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _generateNextEvent();
  }

  @override
  void dispose() {
    _ageAnimationController.dispose();
    _moneyAnimationController.dispose();
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
      appBar: AppBar(
        title: const Text('Life Simulator'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: gameEnded ? _buildGameEndScreen() : _buildGameScreen(),
    );
  }

  Widget _buildGameScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCharacterStats(),
          const SizedBox(height: 20),
          if (activeEvent != null) _buildEventCard(),
        ],
      ),
    );
  }

  Widget _buildCharacterStats() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _buildCharacterAvatar(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Age: ${character.age}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('Job: ${character.job}'),
                      Text('Money: \$${_formatMoney(character.money)}'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProgressBar('Happiness', character.happiness, 100, Colors.orange),
            const SizedBox(height: 8),
            _buildProgressBar('Education', character.education, 100, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterAvatar() {
    IconData icon;
    Color color;
    
    if (character.age < 25) {
      icon = Icons.school;
      color = Colors.green;
    } else if (character.age < 40) {
      icon = Icons.work;
      color = Colors.blue;
    } else if (character.age < 60) {
      icon = Icons.family_restroom;
      color = Colors.purple;
    } else {
      icon = Icons.elderly;
      color = Colors.grey;
    }

    return CircleAvatar(
      radius: 40,
      backgroundColor: color.withOpacity(0.2),
      child: Icon(icon, size: 40, color: color),
    );
  }

  Widget _buildProgressBar(String label, int value, int max, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text('$value/$max'),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value / max,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildEventCard() {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activeEvent!.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              activeEvent!.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ...activeEvent!.choices.map((choice) => _buildChoiceButton(choice)),
          ],
        ),
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
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              choice.text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (choice.moneyImpact != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: choice.moneyImpact > 0 ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${choice.moneyImpact > 0 ? '+' : ''}\$${_formatMoney(choice.moneyImpact)}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                if (choice.moneyImpact != 0 && choice.happinessImpact != 0)
                  const SizedBox(width: 8),
                if (choice.happinessImpact != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: choice.happinessImpact > 0 ? Colors.orange : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${choice.happinessImpact > 0 ? '+' : ''}${choice.happinessImpact} 😊',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameEndScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flag, size: 80, color: Colors.gold),
            const SizedBox(height: 20),
            const Text(
              'Life Complete!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('Final Age: ${character.age}'),
                    Text('Final Net Worth: \$${_formatMoney(character.money)}'),
                    Text('Happiness Score: ${character.happiness}/100'),
                    Text('Life Satisfaction: ${_getLifeRating()}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetGame,
              child: const Text('Start New Life'),
            ),
          ],
        ),
      ),
    );
  }

  void _makeChoice(LifeChoice choice) {
    setState(() {
      character.money += choice.moneyImpact;
      character.happiness = (character.happiness + choice.happinessImpact).clamp(0, 100);
      character.age += random.nextInt(3) + 1; // Age 1-3 years
      
      // Apply effects
      choice.effects.forEach((key, value) {
        switch (key) {
          case 'education':
            character.education = (character.education + value).clamp(0, 100);
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
    
    if (character.age >= 80) {
      _endGame();
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        _generateNextEvent();
      });
    }
  }

  void _showChoiceResult(LifeChoice choice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Result'),
        content: Text(choice.consequence),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
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
      _generateNextEvent();
    });
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
