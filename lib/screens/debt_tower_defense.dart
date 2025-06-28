// lib/screens/debt_tower_defense.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class FloatingText {
  Offset position;
  final String text;
  final Color color;
  double life;
  final double maxLife;
  
  FloatingText({
    required this.position,
    required this.text,
    required this.color,
    required this.life,
  }) : maxLife = life;
  
  void update() {
    position = Offset(position.dx, position.dy - 1); // Float upward
    life -= 0.015;
  }
  
  bool get isAlive => life > 0;
}

class Particle {
  Offset position;
  final Offset velocity;
  final Color color;
  double life;
  final double maxLife;
  final double size;
  
  Particle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.life,
    required this.size,
  }) : maxLife = life;
  
  void update() {
    position += velocity;
    life -= 0.02;
  }
  
  bool get isAlive => life > 0;
}

class Bullet {
  final Offset start;
  final Offset target;
  Offset position;
  final Color color;
  final double speed;
  final double damage;
  bool isActive;
  
  Bullet({
    required this.start,
    required this.target,
    required this.color,
    this.speed = 5.0,
    required this.damage,
  }) : position = start, isActive = true;
  
  void update() {
    if (!isActive) return;
    
    final direction = target - start;
    final distance = direction.distance;
    final normalizedDirection = direction / distance;
    
    position += normalizedDirection * speed;
    
    // Check if bullet reached target
    if ((position - target).distance < 10) {
      isActive = false;
    }
  }
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
  List<Bullet> activeBullets = [];
  List<Particle> particles = [];
  List<FloatingText> floatingTexts = [];
  int playerMoney = 800; // Reduced starting money for more challenge
  int playerHealth = 50; // Reduced health for more challenge
  int currentWave = 1;
  int maxWaves = 5; // Limited to 5 waves
  bool gameStarted = false;
  bool gameOver = false;
  bool waveInProgress = false;
  bool isPaused = false;
  
  // Selected tower for placement
  DefenseTower? selectedTowerType;
  Offset? _hoverPosition;
  
  // Animation controllers
  late AnimationController _gameController;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  Timer? _gameTimer;
  
  final Random random = Random();

  // Enhanced tower types with more challenging balance
  final List<DefenseTower> availableTowers = [
    DefenseTower(
      name: 'Salary',
      cost: 200, // Increased cost for challenge
      damage: 18, // Reduced damage
      range: 100, // Reduced range
      fireRate: 1.0, // Slower firing
      color: Colors.blue,
      icon: Icons.work,
      description: 'Basic income - affordable but limited',
    ),
    DefenseTower(
      name: 'Investment',
      cost: 400, // Increased cost
      damage: 35, // Moderate damage
      range: 90, // Reduced range
      fireRate: 0.7, // Slower firing
      color: Colors.green,
      icon: Icons.trending_up,
      description: 'High damage - expensive investment',
    ),
    DefenseTower(
      name: 'Side Hustle',
      cost: 150, // Increased cost
      damage: 10, // Reduced damage
      range: 70, // Reduced range
      fireRate: 2.0, // Still fast but less damage
      color: Colors.orange,
      icon: Icons.flash_on,
      description: 'Fast firing - low individual damage',
    ),
    DefenseTower(
      name: 'Budget Shield',
      cost: 300, // Increased cost
      damage: 8, // Reduced damage
      range: 120, // Reduced range
      fireRate: 0.8, // Slower firing
      color: Colors.purple,
      icon: Icons.security,
      description: 'Wide range - defensive strategy',
    ),
    DefenseTower(
      name: 'Crypto Mining',
      cost: 600, // Expensive new tower
      damage: 50, // High damage
      range: 80, // Limited range
      fireRate: 0.5, // Very slow
      color: Colors.amber,
      icon: Icons.currency_bitcoin,
      description: 'High risk, high reward - slow but powerful',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _gameController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _gameController.dispose();
    _pulseController.dispose();
    _shakeController.dispose();
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
        health: 40.0 + (wave * 15), // Increased health
        speed: 1.0 + (wave * 0.1), // Faster speed
        damage: 12 + (wave * 2), // More damage
        color: Colors.red,
        icon: Icons.credit_card,
      ),
      DebtMonster(
        name: 'Student Loan',
        health: 100.0 + (wave * 30), // Much tankier
        speed: 0.5 + (wave * 0.05), // Slightly faster each wave
        damage: 30 + (wave * 3), // More damage
        color: Colors.blue,
        icon: Icons.school,
      ),
      DebtMonster(
        name: 'Car Payment',
        health: 60.0 + (wave * 20), // Increased health
        speed: 0.8 + (wave * 0.08), // Faster speed
        damage: 18 + (wave * 2), // More damage
        color: Colors.orange,
        icon: Icons.directions_car,
      ),
      DebtMonster(
        name: 'Medical Bill',
        health: 120.0 + (wave * 40), // Very tanky
        speed: 0.4 + (wave * 0.03), // Slow but deadly
        damage: 40 + (wave * 4), // High damage
        color: Colors.purple,
        icon: Icons.local_hospital,
      ),
      DebtMonster(
        name: 'Tax Debt',
        health: 80.0 + (wave * 25), // New challenging enemy
        speed: 0.7 + (wave * 0.07),
        damage: 25 + (wave * 3),
        color: Colors.brown,
        icon: Icons.receipt_long,
      ),
    ];

    // More monsters per wave for increased difficulty
    final baseCount = 5 + (wave * 2); // Starts with 5, increases by 2 each wave
    for (int i = 0; i < baseCount; i++) {
      monsters.add(monsterTypes[random.nextInt(monsterTypes.length)]);
    }

    // Boss monster every wave starting from wave 3
    if (wave >= 3) {
      monsters.add(
        DebtMonster(
          name: 'Debt Collector Boss',
          health: 250.0 + (wave * 100), // Very tough boss
          speed: 0.3 + (wave * 0.02),
          damage: 60 + (wave * 10), // Devastating damage
          color: Colors.black,
          icon: Icons.gavel,
        ),
      );
    }

    // Final boss on wave 5
    if (wave == 5) {
      monsters.add(
        DebtMonster(
          name: 'Financial Ruin',
          health: 500.0, // Massive health
          speed: 0.4,
          damage: 100, // Game-ending damage
          color: Colors.red[900]!,
          icon: Icons.warning,
        ),
      );
    }

    return monsters;
  }

  void _updateGame() {
    if (!gameStarted || gameOver || isPaused) return;

    try {
      setState(() {
        // Update floating texts safely
        for (int i = floatingTexts.length - 1; i >= 0; i--) {
          if (i < floatingTexts.length) {
            floatingTexts[i].update();
            if (!floatingTexts[i].isAlive) {
              floatingTexts.removeAt(i);
            }
          }
        }
        
        // Update particles safely
        for (int i = particles.length - 1; i >= 0; i--) {
          if (i < particles.length) {
            particles[i].update();
            if (!particles[i].isAlive) {
              particles.removeAt(i);
            }
          }
        }
        
        // Update bullets safely
        for (int i = activeBullets.length - 1; i >= 0; i--) {
          if (i < activeBullets.length) {
            activeBullets[i].update();
            if (!activeBullets[i].isActive) {
              activeBullets.removeAt(i);
            }
          }
        }
        
        // Move monsters safely
        for (int i = activeMonsters.length - 1; i >= 0; i--) {
          if (i < activeMonsters.length) {
            final monster = activeMonsters[i];
            final newPosition = monster.position + monster.speed;
            
            if (newPosition >= 100) {
              // Monster reached the end - shake screen
              _shakeController.forward().then((_) => _shakeController.reset());
              playerHealth -= monster.damage;
              activeMonsters.removeAt(i);
              
              // Add haptic feedback
              HapticFeedback.mediumImpact();
              
              if (playerHealth <= 0) {
                _endGame(false);
                return;
              }
            } else {
              activeMonsters[i] = monster.copyWith(position: newPosition);
            }
          }
        }

        // Tower attacks safely
        for (final tower in List<DefenseTower>.from(placedTowers)) {
          _towerAttack(tower);
        }

        // Check if wave is complete
        if (activeMonsters.isEmpty && waveInProgress) {
          _completeWave();
        }
      });
    } catch (e) {
      // Prevent crashes by catching any errors
      debugPrint('Game update error: $e');
    }
  }

  void _towerAttack(DefenseTower tower) {
    if (tower.position == null) return;
    
    final now = DateTime.now().millisecondsSinceEpoch.toDouble();
    
    if (now - tower.lastFired < (1000 / tower.fireRate)) return;
    
    // Find closest monster in range
    DebtMonster? targetMonster;
    double closestDistance = double.infinity;
    
    for (final monster in List<DebtMonster>.from(activeMonsters)) {
      try {
        final monsterPos = _getMonsterPosition(monster);
        final distance = _calculateDistance(tower.position!, monsterPos);
        
        if (distance <= tower.range && distance < closestDistance) {
          targetMonster = monster;
          closestDistance = distance;
        }
      } catch (e) {
        // Skip this monster if there's an error
        continue;
      }
    }
    
    if (targetMonster != null) {
      try {
        // Create bullet with enhanced visuals
        final bullet = Bullet(
          start: tower.position!,
          target: _getMonsterPosition(targetMonster),
          color: tower.color,
          damage: tower.damage,
          speed: 8.0,
        );
        activeBullets.add(bullet);
        
        // Damage monster
        final newHealth = targetMonster.health - tower.damage;
        final monsterIndex = activeMonsters.indexOf(targetMonster);
        
        if (monsterIndex >= 0 && monsterIndex < activeMonsters.length) {
          if (newHealth <= 0) {
            // Monster destroyed - create explosion particles
            final monsterPos = _getMonsterPosition(targetMonster);
            _createExplosionParticles(monsterPos, targetMonster.color);
                 final reward = 25 + (currentWave * 5); // Reduced rewards for challenge
        
        // Create floating money text
        floatingTexts.add(FloatingText(
          position: monsterPos,
          text: '+\$$reward',
          color: Colors.green,
          life: 2.0,
        ));
            
            // Add haptic feedback for successful hit
            HapticFeedback.lightImpact();
            
            activeMonsters.removeAt(monsterIndex);
            playerMoney += reward;
          } else {
            activeMonsters[monsterIndex] = targetMonster.copyWith(health: newHealth);
          }
        }
        
        tower.lastFired = now;
      } catch (e) {
        // Handle any errors in attack logic
        debugPrint('Tower attack error: $e');
      }
    }
  }

  void _createExplosionParticles(Offset position, Color color) {
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * pi;
      final velocity = Offset(
        cos(angle) * (2 + random.nextDouble() * 3),
        sin(angle) * (2 + random.nextDouble() * 3),
      );
      
      particles.add(Particle(
        position: position,
        velocity: velocity,
        color: color,
        life: 1.0,
        size: 3 + random.nextDouble() * 3,
      ));
    }
  }

  double _calculateDistance(Offset point1, Offset point2) {
    return (point1 - point2).distance;
  }

  Offset _getMonsterPosition(DebtMonster monster) {
    try {
      // Convert monster position (0-100) to screen coordinates safely
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final gameFieldHeight = screenHeight * 0.6; // Approximate game field height
      
      return Offset(
        (screenWidth * (monster.position / 100)).clamp(0.0, screenWidth),
        (gameFieldHeight * 0.5).clamp(0.0, gameFieldHeight), // Keep on path
      );
    } catch (e) {
      // Fallback position if there's an error
      return const Offset(100, 200);
    }
  }

  void _completeWave() {
    setState(() {
      waveInProgress = false;
      currentWave++;
      playerMoney += 150 + (currentWave * 30); // Reduced wave bonus for challenge
    });
    
    _gameTimer?.cancel();
    
    // Add haptic feedback for wave completion
    HapticFeedback.heavyImpact();
    
    // Show enhanced wave completion dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.amber, width: 2),
        ),
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber[400]!, Colors.amber[600]!],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.military_tech, size: 32, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                'Wave ${currentWave - 1} Complete!',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[400]!, Colors.green[600]!],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.account_balance_wallet, size: 40, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    'Bonus: \$${150 + ((currentWave - 1) * 30)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              currentWave <= maxWaves 
                ? 'Wave $currentWave incoming... Brace yourself!'
                : 'Final wave completed! You survived!',
              style: TextStyle(
                color: currentWave <= maxWaves ? Colors.orange : Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.of(context).pop();
              if (currentWave <= maxWaves) {
                _startWave();
              } else {
                _endGame(true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              currentWave <= maxWaves ? '⚔️ CONTINUE' : '🏆 VICTORY!',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
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
              color: victory ? Colors.amber : Colors.red,
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
      activeBullets.clear();
      particles.clear();
      floatingTexts.clear();
      playerMoney = 800; // Challenging starting money
      playerHealth = 50; // Challenging starting health
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
      backgroundColor: const Color(0xFF0A0A0F), // Deep dark background
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red[400]!, Colors.red[700]!],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.shield, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'Debt Monster Defense',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1A2E),
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: Colors.red.withOpacity(0.3),
        actions: [
          if (gameStarted && !gameOver)
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isPaused 
                    ? [Colors.green[400]!, Colors.green[600]!]
                    : [Colors.orange[400]!, Colors.orange[600]!],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                onPressed: () {
                  HapticFeedback.selectionClick();
                  setState(() => isPaused = !isPaused);
                },
              ),
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A0F),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: Column(
          children: [
            _buildEnhancedGameStats(),
            Expanded(
              child: AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final shakeOffset = _shakeController.value * 8;
                  return Transform.translate(
                    offset: Offset(
                      (random.nextDouble() - 0.5) * shakeOffset,
                      (random.nextDouble() - 0.5) * shakeOffset,
                    ),
                    child: Stack(
                      children: [
                        _buildEnhancedGameField(),
                        if (!gameStarted) _buildEnhancedStartButton(),
                        if (isPaused) _buildPauseOverlay(),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildEnhancedTowerSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedGameStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1A1A2E),
            const Color(0xFF16213E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.cyan.withOpacity(0.3),
            width: 2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildEnhancedStatItem(
            '💰', 
            '\$$playerMoney', 
            Colors.green, 
            'Money',
            Icons.attach_money,
          ),
          _buildEnhancedStatItem(
            '❤️', 
            '$playerHealth', 
            playerHealth > 30 
              ? Colors.green 
              : playerHealth > 15 
                ? Colors.orange 
                : Colors.red, 
            'Health',
            Icons.favorite,
          ),
          _buildEnhancedStatItem(
            '🌊', 
            '$currentWave/$maxWaves', 
            currentWave <= 3 ? Colors.blue : Colors.orange, 
            'Wave',
            Icons.waves,
          ),
          if (waveInProgress)
            _buildEnhancedStatItem(
              '👹', 
              '${activeMonsters.length}', 
              Colors.red, 
              'Enemies',
              Icons.bug_report,
            ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatItem(String emoji, String value, Color color, String label, IconData icon) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_pulseController.value * 0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.2),
                  color.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withOpacity(0.6),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[300],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedGameField() {
    return GestureDetector(
      onTapDown: (details) => _placeTower(details.localPosition),
      onPanUpdate: (details) {
        // Update hover position for range preview
        if (selectedTowerType != null) {
          setState(() {
            // This will trigger a repaint with new hover position
          });
        }
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green[900]!,
              Colors.green[700]!,
              Colors.green[500]!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: MouseRegion(
          onHover: (event) {
            if (selectedTowerType != null) {
              setState(() {
                _hoverPosition = event.localPosition;
              });
            }
          },
          child: CustomPaint(
            painter: EnhancedGameFieldPainter(
              monsters: activeMonsters,
              towers: placedTowers,
              bullets: activeBullets,
              particles: particles,
              floatingTexts: floatingTexts,
              selectedTowerType: selectedTowerType,
              hoverPosition: _hoverPosition,
              animationValue: _gameController.value,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedStartButton() {
    return Center(
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_pulseController.value * 0.1),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.red[400]!,
                    Colors.red[600]!,
                    Colors.red[800]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.6),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 50,
                    spreadRadius: 10,
                  ),
                ],
                border: Border.all(
                  color: Colors.red[300]!,
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      _startGame();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red[600],
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                      shadowColor: Colors.white.withOpacity(0.5),
                    ),
                    child: const Text(
                      'START DEFENSE!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          '🎯 Tap to place towers',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '🛡️ Defend your financial future!',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
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

  Widget _buildPauseOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1A1A2E),
                const Color(0xFF16213E),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.blue[300]!, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[400]!, Colors.blue[600]!],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pause_circle,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Game Paused',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Take a breath, strategize your defense!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  setState(() => isPaused = false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 8,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow, size: 24),
                    SizedBox(width: 8),
                    Text(
                      'Resume Battle',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

  Widget _buildEnhancedTowerSelector() {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF16213E),
            const Color(0xFF1A1A2E),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          top: BorderSide(
            color: Colors.cyan.withOpacity(0.3),
            width: 2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          if (selectedTowerType != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    selectedTowerType!.color.withOpacity(0.3),
                    selectedTowerType!.color.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: selectedTowerType!.color, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: selectedTowerType!.color.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selectedTowerType!.icon,
                    color: selectedTowerType!.color,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${selectedTowerType!.name} Selected - Tap field to place',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: availableTowers.length,
              itemBuilder: (context, index) {
                final tower = availableTowers[index];
                final canAfford = playerMoney >= tower.cost;
                final isSelected = selectedTowerType?.name == tower.name;
                
                return GestureDetector(
                  onTap: canAfford ? () {
                    HapticFeedback.selectionClick();
                    _selectTower(tower);
                  } : () {
                    HapticFeedback.heavyImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('💰 Need \$${tower.cost - playerMoney} more!'),
                        duration: const Duration(seconds: 1),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 85, // Slightly smaller to fit 5 towers
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isSelected 
                          ? [tower.color, tower.color.withOpacity(0.7)]
                          : canAfford 
                            ? [
                                const Color(0xFF2A2A3E),
                                const Color(0xFF1E1E32),
                              ]
                            : [
                                const Color(0xFF1A1A1A),
                                const Color(0xFF0F0F0F),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected 
                          ? Colors.white
                          : canAfford 
                            ? tower.color.withOpacity(0.5)
                            : Colors.grey[800]!,
                        width: isSelected ? 3 : 2,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: tower.color.withOpacity(0.6),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ] : canAfford ? [
                        BoxShadow(
                          color: tower.color.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ] : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: canAfford 
                              ? LinearGradient(
                                  colors: [tower.color, tower.color.withOpacity(0.7)],
                                )
                              : LinearGradient(
                                  colors: [Colors.grey[600]!, Colors.grey[800]!],
                                ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            tower.icon,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 4), // Reduced spacing
                        Text(
                          tower.name,
                          style: TextStyle(
                            fontSize: 8, // Reduced font size
                            fontWeight: FontWeight.bold,
                            color: canAfford 
                              ? (isSelected ? Colors.white : Colors.white70) 
                              : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2), // Reduced spacing
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), // Reduced padding
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: canAfford 
                                ? [Colors.green[400]!, Colors.green[600]!]
                                : [Colors.red[400]!, Colors.red[600]!],
                            ),
                            borderRadius: BorderRadius.circular(8), // Reduced radius
                          ),
                          child: Text(
                            '\$${tower.cost}',
                            style: const TextStyle(
                              fontSize: 7, // Reduced font size
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _selectTower(DefenseTower tower) {
    setState(() {
      selectedTowerType = tower;
    });
  }

  void _placeTower(Offset position) {
    if (selectedTowerType == null || playerMoney < selectedTowerType!.cost) {
      if (selectedTowerType != null) {
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Text('💰 Need \$${selectedTowerType!.cost - playerMoney} more!'),
              ],
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
      return;
    }
    
    try {
      // Check if position is valid (not too close to other towers and not on path)
      bool validPosition = true;
      String errorMessage = '';
      
      final screenHeight = MediaQuery.of(context).size.height;
      final pathY = screenHeight * 0.4;
      
      // Check distance from path
      if ((position.dy - pathY).abs() < 50) {
        validPosition = false;
        errorMessage = '🚫 Cannot place on the debt path!';
      }
      
      // Check distance from other towers
      if (validPosition) {
        for (final tower in placedTowers) {
          if (tower.position != null && _calculateDistance(position, tower.position!) < 70) {
            validPosition = false;
            errorMessage = '🚫 Too close to another tower!';
            break;
          }
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
          
          // Success haptic feedback
          HapticFeedback.lightImpact();
          
          // Show success feedback
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('✅ ${newTower.name} tower placed! 💪'),
                ],
              ),
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.green[600],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        });
      } else {
        // Error haptic feedback
        HapticFeedback.heavyImpact();
        
        // Show error feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.warning, color: Colors.white),
                const SizedBox(width: 8),
                Text(errorMessage),
              ],
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      // Handle any unexpected errors
      debugPrint('Tower placement error: $e');
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text('❌ Failed to place tower. Try again!'),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
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

class EnhancedGameFieldPainter extends CustomPainter {
  final List<DebtMonster> monsters;
  final List<DefenseTower> towers;
  final List<Bullet> bullets;
  final List<Particle> particles;
  final List<FloatingText> floatingTexts;
  final DefenseTower? selectedTowerType;
  final Offset? hoverPosition;
  final double animationValue;

  EnhancedGameFieldPainter({
    required this.monsters,
    required this.towers,
    required this.bullets,
    required this.particles,
    required this.floatingTexts,
    this.selectedTowerType,
    this.hoverPosition,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw animated background pattern
    _drawBackgroundPattern(canvas, size);
    
    // Draw path for monsters with glow effect
    _drawPath(canvas, size);
    
    // Draw tower ranges for selected tower
    if (selectedTowerType != null) {
      _drawTowerRangePreview(canvas, size);
    }
    
    // Draw towers with 3D effects
    for (final tower in towers) {
      _drawEnhanced3DTower(canvas, tower);
    }
    
    // Draw monsters with health bars and animations
    for (final monster in monsters) {
      _drawEnhancedMonster(canvas, monster, size);
    }
    
    // Draw bullets with enhanced 3D trails
    for (final bullet in bullets) {
      _drawEnhanced3DBullet(canvas, bullet);
    }
    
    // Draw particles
    for (final particle in particles) {
      _drawParticle(canvas, particle);
    }
    
    // Draw floating texts
    for (final text in floatingTexts) {
      _drawFloatingText(canvas, text);
    }
  }

  void _drawBackgroundPattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.1)
      ..strokeWidth = 1;
    
    // Draw grid pattern
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawPath(Canvas canvas, Size size) {
    final pathPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.brown[600]!, Colors.brown[400]!],
      ).createShader(Rect.fromLTWH(0, size.height * 0.35, size.width, 60))
      ..style = PaintingStyle.fill;
    
    final glowPaint = Paint()
      ..color = Colors.brown.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    
    final rect = Rect.fromLTWH(0, size.height * 0.35, size.width, 60);
    
    // Draw glow
    canvas.drawRect(rect.inflate(5), glowPaint);
    // Draw main path
    canvas.drawRect(rect, pathPaint);
    
    // Draw animated danger indicators at the end
    final dangerPaint = Paint()
      ..color = Colors.red.withOpacity(0.5 + (animationValue * 0.5))
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromLTWH(size.width - 20, size.height * 0.35, 20, 60),
      dangerPaint,
    );
  }

  void _drawTowerRangePreview(Canvas canvas, Size size) {
    if (selectedTowerType == null || hoverPosition == null) return;
    
    final rangePaint = Paint()
      ..color = selectedTowerType!.color.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    final borderPaint = Paint()
      ..color = selectedTowerType!.color.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // Animated pulsing effect
    final pulseSize = selectedTowerType!.range * (1.0 + (animationValue * 0.1));
    
    canvas.drawCircle(hoverPosition!, pulseSize, rangePaint);
    canvas.drawCircle(hoverPosition!, selectedTowerType!.range, borderPaint);
    
    // Draw tower preview
    final previewPaint = Paint()
      ..color = selectedTowerType!.color.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(hoverPosition!, 20, previewPaint);
  }

  void _drawEnhanced3DTower(Canvas canvas, DefenseTower tower) {
    if (tower.position == null) return;
    
    final centerX = tower.position!.dx;
    final centerY = tower.position!.dy;
    
    // Draw tower range (subtle)
    final rangePaint = Paint()
      ..color = tower.color.withOpacity(0.05)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(tower.position!, tower.range, rangePaint);
    
    // 3D Tower Base - Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(Offset(centerX + 2, centerY + 2), 22, shadowPaint);
    
    // 3D Tower Base - Bottom layer (darker)
    final basePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          tower.color.withOpacity(0.3),
          tower.color.withOpacity(0.7),
          tower.color.withOpacity(0.9),
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: tower.position!, radius: 20));
    canvas.drawCircle(tower.position!, 20, basePaint);
    
    // 3D Tower Middle layer
    final middlePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          tower.color.withOpacity(0.8),
          tower.color,
          tower.color.withOpacity(0.6),
        ],
        begin: const Alignment(-0.5, -0.5),
        end: const Alignment(0.5, 0.5),
      ).createShader(Rect.fromCircle(center: tower.position!, radius: 16));
    canvas.drawCircle(tower.position!, 16, middlePaint);
    
    // 3D Tower Top layer (brightest)
    final topPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.8),
          tower.color,
          tower.color.withOpacity(0.8),
        ],
        stops: const [0.0, 0.3, 1.0],
      ).createShader(Rect.fromCircle(center: tower.position!, radius: 12));
    canvas.drawCircle(tower.position!, 12, topPaint);
    
    // Animated glow effect
    final glowIntensity = 0.3 + (animationValue * 0.2);
    final glowPaint = Paint()
      ..color = tower.color.withOpacity(glowIntensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(tower.position!, 18, glowPaint);
    
    // 3D Tower Border/Rim
    final rimPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(tower.position!, 20, rimPaint);
    canvas.drawCircle(tower.position!, 12, rimPaint);
    
    // Tower level indicator (small gems)
    for (int i = 0; i < tower.level; i++) {
      final angle = (i / tower.level) * 2 * pi;
      final gemX = centerX + cos(angle) * 8;
      final gemY = centerY + sin(angle) * 8;
      
      final gemPaint = Paint()
        ..color = Colors.amber
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(gemX, gemY), 2, gemPaint);
    }
    
    // Enhanced tower icon with 3D effect
    final iconShadowPainter = TextPainter(
      text: TextSpan(
        text: _getIconText(tower.icon),
        style: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    iconShadowPainter.layout();
    iconShadowPainter.paint(
      canvas, 
      Offset(centerX - iconShadowPainter.width / 2 + 1, centerY - iconShadowPainter.height / 2 + 1),
    );
    
    final iconPainter = TextPainter(
      text: TextSpan(
        text: _getIconText(tower.icon),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(0.5, 0.5),
              blurRadius: 1,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    iconPainter.paint(
      canvas, 
      Offset(centerX - iconPainter.width / 2, centerY - iconPainter.height / 2),
    );
    
    // Firing animation effect
    if (tower.lastFired > 0 && (DateTime.now().millisecondsSinceEpoch - tower.lastFired) < 200) {
      final flashPaint = Paint()
        ..color = Colors.white.withOpacity(0.7)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(tower.position!, 25, flashPaint);
    }
  }

  void _drawEnhancedMonster(Canvas canvas, DebtMonster monster, Size size) {
    final x = size.width * (monster.position / 100);
    final y = size.height * 0.4;
    final position = Offset(x, y);
    
    // Health bar background
    final healthBarWidth = 35.0;
    final healthBarHeight = 6.0;
    final healthPercent = monster.health / monster.maxHealth;
    
    final healthBarBg = Paint()..color = Colors.red[800]!;
    final healthBarFg = Paint()
      ..shader = LinearGradient(
        colors: [Colors.green, Colors.yellow, Colors.red],
        stops: const [0.6, 0.8, 1.0],
      ).createShader(Rect.fromLTWH(x - healthBarWidth/2, y - 30, healthBarWidth, healthBarHeight));
    
    // Health bar shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x - healthBarWidth/2 + 1, y - 29, healthBarWidth, healthBarHeight),
        const Radius.circular(3),
      ),
      shadowPaint,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x - healthBarWidth/2, y - 30, healthBarWidth, healthBarHeight),
        const Radius.circular(3),
      ),
      healthBarBg,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x - healthBarWidth/2, y - 30, healthBarWidth * healthPercent, healthBarHeight),
        const Radius.circular(3),
      ),
      healthBarFg,
    );

    // Monster glow effect
    final glowPaint = Paint()
      ..color = monster.color.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(position, 18, glowPaint);
    
    // Monster body with gradient
    final monsterPaint = Paint()
      ..shader = RadialGradient(
        colors: [monster.color, monster.color.withOpacity(0.7)],
      ).createShader(Rect.fromCircle(center: position, radius: 15));
    canvas.drawCircle(position, 15, monsterPaint);
    
    // Monster border
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(position, 15, borderPaint);
    
    // Monster icon
    final textPainter = TextPainter(
      text: TextSpan(
        text: _getIconText(monster.icon),
        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width/2, y - textPainter.height/2));
  }

  void _drawEnhanced3DBullet(Canvas canvas, Bullet bullet) {
    if (!bullet.isActive) return;
    
    // Calculate bullet trail
    final trailDirection = (bullet.position - bullet.start).distance > 20 
        ? (bullet.start - bullet.position) / (bullet.start - bullet.position).distance * 20
        : Offset.zero;
    
    // Draw multiple trail segments for motion blur effect
    for (int i = 0; i < 5; i++) {
      final trailPos = bullet.position + (trailDirection * (i / 5));
      final trailAlpha = (1.0 - (i / 5)) * 0.6;
      
      final trailPaint = Paint()
        ..color = bullet.color.withOpacity(trailAlpha)
        ..strokeWidth = (4 - i).toDouble()
        ..strokeCap = StrokeCap.round;
      
      if (i < 4) {
        final nextTrailPos = bullet.position + (trailDirection * ((i + 1) / 5));
        canvas.drawLine(trailPos, nextTrailPos, trailPaint);
      }
    }
    
    // Draw bullet glow (larger)
    final glowPaint = Paint()
      ..color = bullet.color.withOpacity(0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(bullet.position, 6, glowPaint);
    
    // Draw bullet core with 3D gradient
    final bulletPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white,
          bullet.color,
          bullet.color.withOpacity(0.8),
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromCircle(center: bullet.position, radius: 4));
    canvas.drawCircle(bullet.position, 4, bulletPaint);
    
    // Draw bullet highlight for 3D effect
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(bullet.position + const Offset(-1.5, -1.5), 1.5, highlightPaint);
    
    // Energy spark effect
    final sparkPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 1;
    
    for (int i = 0; i < 4; i++) {
      final angle = (i * pi / 2) + (animationValue * 2 * pi);
      final sparkEnd = bullet.position + Offset(cos(angle) * 8, sin(angle) * 8);
      canvas.drawLine(bullet.position, sparkEnd, sparkPaint);
    }
  }

  void _drawParticle(Canvas canvas, Particle particle) {
    final alpha = (particle.life / particle.maxLife).clamp(0.0, 1.0);
    final paint = Paint()
      ..color = particle.color.withOpacity(alpha)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(particle.position, particle.size * alpha, paint);
  }

  void _drawFloatingText(Canvas canvas, FloatingText floatingText) {
    final alpha = (floatingText.life / floatingText.maxLife).clamp(0.0, 1.0);
    final textPainter = TextPainter(
      text: TextSpan(
        text: floatingText.text,
        style: TextStyle(
          color: floatingText.color.withOpacity(alpha),
          fontSize: 16,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(alpha * 0.5),
              offset: const Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        floatingText.position.dx - textPainter.width / 2,
        floatingText.position.dy - textPainter.height / 2,
      ),
    );
  }

  String _getIconText(IconData icon) {
    // Enhanced icon mapping with emojis
    if (icon == Icons.credit_card) return '💳';
    if (icon == Icons.school) return '🎓';
    if (icon == Icons.directions_car) return '🚗';
    if (icon == Icons.local_hospital) return '🏥';
    if (icon == Icons.home) return '🏠';
    if (icon == Icons.work) return '💼';
    if (icon == Icons.trending_up) return '📈';
    if (icon == Icons.flash_on) return '⚡';
    if (icon == Icons.security) return '🛡️';
    if (icon == Icons.currency_bitcoin) return '₿';
    if (icon == Icons.gavel) return '⚖️';
    if (icon == Icons.warning) return '☠️';
    if (icon == Icons.receipt_long) return '📋';
    return '?';
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
