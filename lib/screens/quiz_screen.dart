// lib/screens/quiz_screen.dart
import 'package:flutter/material.dart';
import '../models/game_model.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
}

class QuizScreen extends StatefulWidget {
  final Game game;

  const QuizScreen({super.key, required this.game});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _isAnswered = false;
  bool _showExplanation = false;

  final List<QuizQuestion> _questions = [
    QuizQuestion(
      question: "What percentage of your income should you save each month?",
      options: ["5-10%", "20-30%", "50%", "2-5%"],
      correctAnswer: 1,
      explanation: "Financial experts recommend saving 20-30% of your income - 20% for long-term savings and 10% for emergency funds.",
    ),
    QuizQuestion(
      question: "What is an emergency fund?",
      options: [
        "Money for shopping",
        "3-6 months of expenses saved",
        "Investment money",
        "Vacation savings"
      ],
      correctAnswer: 1,
      explanation: "An emergency fund should cover 3-6 months of your essential expenses and be easily accessible.",
    ),
    QuizQuestion(
      question: "Which is the best first step in creating a budget?",
      options: [
        "Start investing",
        "Track your spending",
        "Buy expensive items",
        "Ignore small expenses"
      ],
      correctAnswer: 1,
      explanation: "Tracking your spending helps you understand where your money goes and identify areas for improvement.",
    ),
    QuizQuestion(
      question: "What does the 50/30/20 rule suggest?",
      options: [
        "50% needs, 30% wants, 20% savings",
        "50% wants, 30% needs, 20% savings",
        "50% savings, 30% needs, 20% wants",
        "Equal split of all expenses"
      ],
      correctAnswer: 0,
      explanation: "The 50/30/20 rule allocates 50% for needs, 30% for wants, and 20% for savings and debt repayment.",
    ),
    QuizQuestion(
      question: "What's the difference between a want and a need?",
      options: [
        "There's no difference",
        "Needs are essential, wants are desires",
        "Wants are more important",
        "Needs cost more money"
      ],
      correctAnswer: 1,
      explanation: "Needs are essential for survival (food, shelter, basic clothing), while wants are things that improve quality of life but aren't essential.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final isLastQuestion = _currentQuestionIndex == _questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.title),
        backgroundColor: widget.game.color,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProgressBar(),
            const SizedBox(height: 24),
            _buildQuestionCard(question),
            const SizedBox(height: 24),
            if (_showExplanation) _buildExplanation(question),
            const Spacer(),
            _buildActionButton(isLastQuestion),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Score: $_score/${_currentQuestionIndex + (_isAnswered ? 1 : 0)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _questions.length,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(widget.game.color),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(QuizQuestion question) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...question.options.asMap().entries.map(
              (entry) => _buildOptionTile(entry.key, entry.value, question.correctAnswer),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(int index, String option, int correctAnswer) {
    Color? tileColor;
    Color? textColor;

    if (_isAnswered) {
      if (index == correctAnswer) {
        tileColor = Colors.green;
        textColor = Colors.white;
      } else if (index == _selectedAnswer && index != correctAnswer) {
        tileColor = Colors.red;
        textColor = Colors.white;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        tileColor: tileColor,
        title: Text(
          option,
          style: TextStyle(
            color: textColor,
            fontWeight: _selectedAnswer == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: tileColor ?? Colors.grey[200],
          child: Text(
            String.fromCharCode(65 + index), // A, B, C, D
            style: TextStyle(
              color: textColor ?? Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: _isAnswered ? null : () => _selectAnswer(index),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildExplanation(QuizQuestion question) {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Explanation',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(question.explanation),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(bool isLastQuestion) {
    String buttonText;
    VoidCallback? onPressed;

    if (!_isAnswered) {
      buttonText = 'Submit Answer';
      onPressed = _selectedAnswer != null ? _submitAnswer : null;
    } else if (_showExplanation) {
      buttonText = isLastQuestion ? 'Finish Quiz' : 'Next Question';
      onPressed = isLastQuestion ? _finishQuiz : _nextQuestion;
    } else {
      buttonText = 'Show Explanation';
      onPressed = () => setState(() => _showExplanation = true);
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.game.color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _selectAnswer(int index) {
    setState(() {
      _selectedAnswer = index;
    });
  }

  void _submitAnswer() {
    final question = _questions[_currentQuestionIndex];
    final isCorrect = _selectedAnswer == question.correctAnswer;

    setState(() {
      _isAnswered = true;
      if (isCorrect) _score++;
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _selectedAnswer = null;
      _isAnswered = false;
      _showExplanation = false;
    });
  }

  void _finishQuiz() {
    final percentage = (_score / _questions.length * 100).round();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              percentage >= 80 ? Icons.star : Icons.thumb_up,
              size: 64,
              color: percentage >= 80 ? Colors.amber : Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              'Your Score: $_score/${_questions.length} ($percentage%)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'XP Earned: ${widget.game.xpReward}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Coins Earned: ${widget.game.coinsReward}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to game screen
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
