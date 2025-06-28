import 'package:flutter/material.dart';
import 'dart:io';
//import 'transactions_screen.dart';
import 'financial_survival_quest_expert.dart'; // Direct import for Life Simulation
import 'dashboard_screen.dart';
import 'login_screen.dart';
import '/screens/account_settings_screen.dart';
import '/screens/appearance_settings_screen.dart';
import '/theme/savora_theme.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final void Function(ThemeMode) onThemeChanged;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.onThemeChanged,
  });

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? _profileImagePath;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _buildDashboardScreen(),
      const FinancialSurvivalQuest(), // Direct Life Simulation access
    ];
  }

  Widget _buildDashboardScreen() {
    return DashboardScreen(
      userName: widget.userName,
      profileImagePath: _profileImagePath,
      onImageUpdated: (path) {
        setState(() {
          _profileImagePath = path;
        });
      },
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleMenuSelection(String value) async {
    if (value == 'logout') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginScreen(onThemeChanged: widget.onThemeChanged),
        ),
      );
    } else if (value == 'account') {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AccountSettingsScreen(
            userName: widget.userName,
            profileImagePath: _profileImagePath,
            onImageUpdated: (path) {
              setState(() {
                _profileImagePath = path;
              });
            },
          ),
        ),
      );
    } else if (value == 'appearance') {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              AppearanceSettingsScreen(onThemeChanged: widget.onThemeChanged),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: _profileImagePath != null
                  ? FileImage(File(_profileImagePath!))
                  : null,
              child: _profileImagePath == null
                  ? Icon(Icons.person, size: 16, color: SavoraColors.primary)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              widget.userName,
              style: context.savoraText.titleLarge?.copyWith(
                color: context.savoraColors.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) => const [
              PopupMenuItem<String>(
                value: 'account',
                child: Text('Account Settings'),
              ),
              PopupMenuItem<String>(
                value: 'appearance',
                child: Text('Appearance'),
              ),
              PopupMenuItem<String>(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Life Simulation',
          ),
        ],
      ),
    );
  }
}
