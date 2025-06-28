import 'package:flutter/material.dart';
import 'lib/screens/life_simulator_game.dart';

void main() {
  runApp(const TestLifeSimulatorApp());
}

class TestLifeSimulatorApp extends StatelessWidget {
  const TestLifeSimulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Simulator Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const LifeSimulatorGame(),
    );
  }
}
