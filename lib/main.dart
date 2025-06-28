import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/screens/login_screen.dart';
import '/theme/savora_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('themeMode') ?? 'system';
  final ThemeMode initialThemeMode = _stringToThemeMode(savedTheme);

  runApp(MyApp(initialThemeMode: initialThemeMode));
}

ThemeMode _stringToThemeMode(String mode) {
  switch (mode) {
    case 'dark':
      return ThemeMode.dark;
    case 'light':
      return ThemeMode.light;
    case 'system':
      return ThemeMode.system;
  }
  return ThemeMode.system; // fallback (still needed if mode is invalid)
}

class MyApp extends StatefulWidget {
  final ThemeMode initialThemeMode;

  const MyApp({super.key, required this.initialThemeMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
  }

  void _updateThemeMode(ThemeMode newMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', _themeModeToString(newMode));
    setState(() {
      _themeMode = newMode;
    });
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAVORA',
      debugShowCheckedModeBanner: false,
      theme: SavoraTheme.lightTheme,
      darkTheme: SavoraTheme.darkTheme,
      themeMode: _themeMode,
      home: LoginScreen(onThemeChanged: _updateThemeMode),
    );
  }
}
