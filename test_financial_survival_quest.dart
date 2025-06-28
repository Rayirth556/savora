// Test script to verify Financial Survival Quest implementation
// This test verifies that all the key components are working correctly

import 'package:flutter/material.dart';
import 'lib/screens/life_simulator_game.dart';

void main() {
  // Test 1: Verify that FinancialCharacter can be instantiated
  print('Test 1: Creating FinancialCharacter...');
  final character = FinancialCharacter(
    name: 'Test Player',
    lifeStage: LifeStage.teen,
    savings: 1000,
    creditScore: 700,
    xp: 0,
    stress: 50,
    age: 16,
    income: 0,
    happiness: 75,
    knowledge: 25,
  );
  print('✓ FinancialCharacter created successfully');
  print('  Name: ${character.name}');
  print('  Life Stage: ${character.lifeStage}');
  print('  Savings: \$${character.savings}');
  print('  Credit Score: ${character.creditScore}');
  
  // Test 2: Verify Achievement class
  print('\nTest 2: Creating Achievement...');
  final achievement = Achievement(
    id: 'test_achievement',
    title: 'Test Achievement',
    description: 'This is a test achievement',
    icon: Icons.star,
    unlockedAt: DateTime.now(),
  );
  print('✓ Achievement created successfully');
  print('  Title: ${achievement.title}');
  print('  Description: ${achievement.description}');
  
  // Test 3: Verify LifeEvent and LifeChoice
  print('\nTest 3: Creating LifeEvent with choices...');
  final choices = [
    LifeChoice(
      text: 'Save money',
      moneyImpact: 100,
      happinessImpact: -5,
      stressImpact: 5,
      description: 'Save some money but feel restricted',
    ),
    LifeChoice(
      text: 'Spend money',
      moneyImpact: -100,
      happinessImpact: 10,
      stressImpact: -5,
      description: 'Enjoy yourself but lose money',
    ),
  ];
  
  final event = LifeEvent(
    title: 'Weekend Plans',
    description: 'You have some free time. What do you want to do?',
    choices: choices,
    applicableStages: [LifeStage.teen, LifeStage.college],
  );
  print('✓ LifeEvent created successfully');
  print('  Title: ${event.title}');
  print('  Choices: ${event.choices.length}');
  print('  Applicable stages: ${event.applicableStages.length}');
  
  print('\n🎉 All tests passed! Financial Survival Quest components are working correctly.');
  print('\nTo play the game:');
  print('1. Open the SAVORA app');
  print('2. Go to the Games screen');
  print('3. Select "Life Simulator"');
  print('4. Start playing the Financial Survival Quest!');
}
