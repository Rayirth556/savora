// lib/screens/game_screen.dart
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Games')),
      body: Center(child: Text('Game content coming soon...', style: TextStyle(fontSize: 18))),
    );
  }
}
