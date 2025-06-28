// lib/screens/debt_tower_defense.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class DebtMonster {
  final String name;
  final double health;
  final double maxHealth;
  final double speed;
  final int damage;
  final Color color;
  final IconData icon;
  double position;
  
  DebtMonster({
    required this.name,
    required this.health,
    required this.speed,
    required this.damage,
    required this.color,
    required this.icon,
    this.position = 0.0,
  }) : maxHealth = health;

  DebtMonster copyWith({double? health, double? position}) {
    return DebtMonster(
      name: name,
      health: health ?? this.health,
      speed: speed,
      damage: damage,
      color: color,
      icon: icon,
      position: position ?? this.position,
    );
  }
}

class DefenseTower {
  final String name;
  final int cost;
  final double damage;
  final double range;
  final double fireRate;
  final Color color;
  final IconData icon;
  final String description;
  Offset? position;
  double lastFired;
  int level;
  
  DefenseTower({
    required this.name,
    required this.cost,
    required this.damage,
    required this.range,
    required this.fireRate,
    required this.color,
    required this.icon,
    required this.description,
    this.position,
    this.lastFired = 0,
    this.level = 1,
  });
}

class DebtTowerDefenseGame extends StatefulWidget {
  const DebtTowerDefenseGame({super.key});

  @override
  State<DebtTowerDefenseGame> createState() => _DebtTowerDefenseGameState();
}

class _DebtTowerDefenseGameState extends State<DebtTowerDefenseGame>
    with TickerProviderStateMixin {
  
  // Game state
  List<DebtMonster> activeMonsters = [];
  List<DefenseTower> placedTowers = [];
  int playerMoney = 1000;
  int playerHealth = 100;
  int currentWave = 1;
  bool gameStarted = false;
  bool gameOver = false;
  bool waveInProgress = false;
  
  // Selected tower for placement
  DefenseTower? selectedTowerType;
  
  // Animation
  late AnimationController _gameController;
  Timer? _gameTimer;
  
  final Random random = Random();

  // Tower types available
  final List<DefenseTower> availableTowers = [
    DefenseTower(
      name: 'Salary Tower',
      cost: 200,
      damage: 15,
      range: 100,
      fireRate: 1.0,
      color: Colors.blue,
      icon: Icons.work,
      description: 'Steady income stream that fights debt consistently',
    ),
    DefenseTower(
      name: 'Investment Tower',
      cost: 400,
      damage: 25,
      range: 80,
      fireRate: 0.7,
      color: Colors.green,
      icon: Icons.trending_up,
      description: 'Grows stronger over time with compound interest',
    ),
    DefenseTower(
      name: 'Side Hustle',
      cost: 150,
      damage: 10,
      range: 60,
      fireRate: 1.5,
      color: Colors.orange,
      icon: Icons.flash_on,
      description: 'Quick bursts of income, fast firing rate',
    ),
    DefenseTower(
      name: 'Budget Shield',
      cost: 300,
      damage: 5,
      range: 120,
      fireRate: 0.5,
      color: Colors.purple,
      icon: Icons.security,
      description: 'Reduces damage from all debt monsters in range',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _gameController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _gameController.dispose();
    _gameTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      gameStarted = true;
      _startWave();
    });
  }

  void _startWave() {
    setState(() {
      waveInProgress = true;
    });
    
    _spawnWave(currentWave);
    
    _gameTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _updateGame();
    });
  }

  void _spawnWave(int waveNumber) {
    final monstersToSpawn = _generateMonstersForWave(waveNumber);
    
    for (int i = 0; i < monstersToSpawn.length; i++) {
      Timer(Duration(milliseconds: i * 1000), () {
        if (mounted) {
          setState(() {
            activeMonsters.add(monstersToSpawn[i]);
          });
        }
      });
    }
  }

  List<DebtMonster> _generateMonstersForWave(int wave) {
    final monsters = <DebtMonster>[];
    final monsterTypes = [
      DebtMonster(
        name: 'Credit Card',
        health: 30.0 + (wave * 10),
        speed: 0.8,
        damage: 10,
        color: Colors.red,
        icon: Icons.credit_card,
      ),
      DebtMonster(
        name: 'Student Loan',
        health: 80.0 + (wave * 20),
        speed: 0.4,
        damage: 25,
        color: Colors.blue,
        icon: Icons.school,
      ),
      DebtMonster(
        name: 'Car Payment',
        health: 50.0 + (wave * 15),
        speed: 0.6,
        damage: 15,
        color: Colors.orange,
        icon: Icons.directions_car,
      ),
      DebtMonster(
        name: 'Medical Bill',
        health: 100.0 + (wave * 30),
        speed: 0.3,
        damage: 30,
        color: Colors.purple,
        icon: Icons.local_hospital,
      ),
    ];

    final baseCount = 3 + (wave ~/ 2);
    for (int i = 0; i < baseCount; i++) {
      monsters.add(monsterTypes[random.nextInt(monsterTypes.length)]);
    }

    // Boss monster every 5 waves
    if (wave % 5 == 0) {
      monsters.add(
        DebtMonster(
          name: 'Mortgage Boss',
          health: 300.0 + (wave * 50),
          speed: 0.2,
          damage: 50,
          color: Colors.black,
          icon: Icons.home,
        ),
      );
    }

    return monsters;
  }

  void _updateGame() {
    if (!gameStarted || gameOver) return;

    setState(() {
      // Move monsters
      for (int i = activeMonsters.length - 1; i >= 0; i--) {
        final monster = activeMonsters[i];
        final newPosition = monster.position + monster.speed;
        
        if (newPosition >= 100) {
          // Monster reached the end
          playerHealth -= monster.damage;
          activeMonsters.removeAt(i);
          
          if (playerHealth <= 0) {
            _endGame(false);
            return;
          }
        } else {
          activeMonsters[i] = monster.copyWith(position: newPosition);
        }
      }

      // Tower attacks
      for (final tower in placedTowers) {
        _towerAttack(tower);
      }

      // Check if wave is complete
      if (activeMonsters.isEmpty && waveInProgress) {
        _completeWave();
      }
    });
  }

  void _towerAttack(DefenseTower tower) {
    final now = DateTime.now().millisecondsSinceEpoch.toDouble();
    
    if (now - tower.lastFired < (1000 / tower.fireRate)) return;
    
    // Find monsters in range
    for (int i = activeMonsters.length - 1; i >= 0; i--) {
      final monster = activeMonsters[i];
      final distance = _calculateDistance(tower.position!, _getMonsterPosition(monster));
      
      if (distance <= tower.range) {
        // Attack the monster
        final newHealth = monster.health - tower.damage;
        
        if (newHealth <= 0) {
          // Monster destroyed
          activeMonsters.removeAt(i);
          playerMoney += 50 + (currentWave * 10); // Reward for killing monster
        } else {
          activeMonsters[i] = monster.copyWith(health: newHealth);
        }
        
        tower.lastFired = now;
        break; // Tower can only attack one monster per shot
      }
    }
  }

  double _calculateDistance(Offset point1, Offset point2) {
    return (point1 - point2).distance;
  }

  Offset _getMonsterPosition(DebtMonster monster) {
    // Convert monster position (0-100) to screen coordinates
    final screenWidth = MediaQuery.of(context).size.width;
    return Offset(screenWidth * (monster.position / 100), 200);
  }

  void _completeWave() {
    setState(() {
      waveInProgress = false;
      currentWave++;
      playerMoney += 200 + (currentWave * 50); // Wave completion bonus
    });
    
    _gameTimer?.cancel();
    
    // Show wave completion dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Wave $currentWave Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.military_tech, size: 64, color: Colors.gold),
            const SizedBox(height: 16),
            Text('Bonus: \$${200 + ((currentWave - 1) * 50)}'),
            const Text('Prepare for the next wave!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (currentWave <= 20) { // Max 20 waves
                _startWave();
              } else {
                _endGame(true);
              }
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _endGame(bool victory) {
    setState(() {
      gameOver = true;
    });
    
    _gameTimer?.cancel();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(victory ? 'Victory!' : 'Game Over'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              victory ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              size: 64,
              color: victory ? Colors.gold : Colors.red,
            ),
            const SizedBox(height: 16),
            Text(victory 
              ? 'You successfully defended against all debt!'
              : 'The debt overwhelmed your defenses!'
            ),
            Text('Final Score: ${currentWave * 1000 + playerMoney}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to game menu
            },
            child: const Text('Main Menu'),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      activeMonsters.clear();
      placedTowers.clear();
      playerMoney = 1000;
      playerHealth = 100;
      currentWave = 1;
      gameStarted = false;
      gameOver = false;
      waveInProgress = false;
      selectedTowerType = null;
    });
    _gameTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debt Tower Defense'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildGameStats(),
          Expanded(
            child: Stack(
              children: [
                _buildGameField(),
                if (!gameStarted) _buildStartButton(),
              ],
            ),
          ),
          _buildTowerSelector(),
        ],
      ),
    );
  }

  Widget _buildGameStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('💰', '\$$playerMoney', Colors.green),
          _buildStatItem('❤️', '$playerHealth', Colors.red),
          _buildStatItem('🌊', 'Wave $currentWave', Colors.blue),
        ],
      ),
    );
  }

  Widget _buildStatItem(String icon, String value, Color color) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
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

  Widget _buildGameField() {
    return GestureDetector(
      onTapDown: (details) => _placeTower(details.localPosition),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[200]!, Colors.green[400]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: CustomPaint(
          painter: GameFieldPainter(
            monsters: activeMonsters,
            towers: placedTowers,
            selectedTowerType: selectedTowerType,
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _startGame,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        child: const Text(
          'START DEFENSE!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTowerSelector() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(8),
      color: Colors.grey[200],
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: availableTowers.length,
        itemBuilder: (context, index) {
          final tower = availableTowers[index];
          final canAfford = playerMoney >= tower.cost;
          final isSelected = selectedTowerType?.name == tower.name;
          
          return GestureDetector(
            onTap: canAfford ? () => _selectTower(tower) : null,
            child: Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected 
                  ? tower.color.withOpacity(0.7)
                  : canAfford 
                    ? Colors.white
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
                border: isSelected 
                  ? Border.all(color: tower.color, width: 3)
                  : Border.all(color: Colors.grey[400]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    tower.icon,
                    color: canAfford ? tower.color : Colors.grey,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tower.name.split(' ')[0], // First word only
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: canAfford ? Colors.black : Colors.grey,
                    ),
                  ),
                  Text(
                    '\$${tower.cost}',
                    style: TextStyle(
                      fontSize: 10,
                      color: canAfford ? Colors.green : Colors.grey,
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

  void _selectTower(DefenseTower tower) {
    setState(() {
      selectedTowerType = tower;
    });
  }

  void _placeTower(Offset position) {
    if (selectedTowerType == null || playerMoney < selectedTowerType!.cost) return;
    
    // Check if position is valid (not too close to other towers)
    bool validPosition = true;
    for (final tower in placedTowers) {
      if (_calculateDistance(position, tower.position!) < 60) {
        validPosition = false;
        break;
      }
    }
    
    if (validPosition) {
      setState(() {
        final newTower = DefenseTower(
          name: selectedTowerType!.name,
          cost: selectedTowerType!.cost,
          damage: selectedTowerType!.damage,
          range: selectedTowerType!.range,
          fireRate: selectedTowerType!.fireRate,
          color: selectedTowerType!.color,
          icon: selectedTowerType!.icon,
          description: selectedTowerType!.description,
          position: position,
        );
        
        placedTowers.add(newTower);
        playerMoney -= selectedTowerType!.cost;
        selectedTowerType = null;
      });
    }
  }
}

class GameFieldPainter extends CustomPainter {
  final List<DebtMonster> monsters;
  final List<DefenseTower> towers;
  final DefenseTower? selectedTowerType;

  GameFieldPainter({
    required this.monsters,
    required this.towers,
    this.selectedTowerType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw path for monsters
    final pathPaint = Paint()
      ..color = Colors.brown[300]!
      ..strokeWidth = 40
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.lineTo(size.width, size.height * 0.4);
    canvas.drawPath(path, pathPaint);

    // Draw monsters
    for (final monster in monsters) {
      _drawMonster(canvas, monster, size);
    }

    // Draw towers
    for (final tower in towers) {
      _drawTower(canvas, tower);
    }
  }

  void _drawMonster(Canvas canvas, DebtMonster monster, Size size) {
    final x = size.width * (monster.position / 100);
    final y = size.height * 0.4;
    
    // Health bar
    final healthBarWidth = 30.0;
    final healthBarHeight = 4.0;
    final healthPercent = monster.health / monster.maxHealth;
    
    final healthBarBg = Paint()..color = Colors.red;
    final healthBarFg = Paint()..color = Colors.green;
    
    canvas.drawRect(
      Rect.fromLTWH(x - healthBarWidth/2, y - 25, healthBarWidth, healthBarHeight),
      healthBarBg,
    );
    canvas.drawRect(
      Rect.fromLTWH(x - healthBarWidth/2, y - 25, healthBarWidth * healthPercent, healthBarHeight),
      healthBarFg,
    );

    // Monster icon
    final monsterPaint = Paint()..color = monster.color;
    canvas.drawCircle(Offset(x, y), 15, monsterPaint);
    
    // Draw icon (simplified as text)
    final textPainter = TextPainter(
      text: TextSpan(
        text: _getIconText(monster.icon),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width/2, y - textPainter.height/2));
  }

  void _drawTower(Canvas canvas, DefenseTower tower) {
    if (tower.position == null) return;
    
    // Tower range (semi-transparent circle)
    final rangePaint = Paint()
      ..color = tower.color.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(tower.position!, tower.range, rangePaint);
    
    // Tower body
    final towerPaint = Paint()..color = tower.color;
    canvas.drawCircle(tower.position!, 20, towerPaint);
    
    // Tower icon
    final textPainter = TextPainter(
      text: TextSpan(
        text: _getIconText(tower.icon),
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas, 
      Offset(
        tower.position!.dx - textPainter.width/2, 
        tower.position!.dy - textPainter.height/2,
      ),
    );
  }

  String _getIconText(IconData icon) {
    // Simple mapping of icons to emoji/text
    if (icon == Icons.credit_card) return '💳';
    if (icon == Icons.school) return '🎓';
    if (icon == Icons.directions_car) return '🚗';
    if (icon == Icons.local_hospital) return '🏥';
    if (icon == Icons.home) return '🏠';
    if (icon == Icons.work) return '💼';
    if (icon == Icons.trending_up) return '📈';
    if (icon == Icons.flash_on) return '⚡';
    if (icon == Icons.security) return '🛡️';
    return '?';
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
