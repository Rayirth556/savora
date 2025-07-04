import 'package:flutter/material.dart';
import '../theme/savora_theme.dart';

extension StringCasingExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}


class AppearanceSettingsScreen extends StatefulWidget {
  final void Function(ThemeMode) onThemeChanged;

  const AppearanceSettingsScreen({
    super.key,
    required this.onThemeChanged,
  });

  @override
  State<AppearanceSettingsScreen> createState() =>
      _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends State<AppearanceSettingsScreen> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    // In-memory only, platformBrightness used only for display fallback.
    _loadInitialThemeMode();
  }

  void _loadInitialThemeMode() {
    // In your case, since themeMode is passed from main.dart,
    // you may pass the currently saved mode here if needed.
    // For now we leave it to `system`.
    // You can also pass initialThemeMode as a parameter if desired.
  }

  @override
  
  Widget build(BuildContext context) {
    // Only used if system is selected
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDark = _themeMode == ThemeMode.system
        ? brightness == Brightness.dark
        : _themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance'),
        backgroundColor: isDark ? SavoraColors.darkSurface : SavoraColors.surface,
        foregroundColor: isDark ? SavoraColors.darkTextPrimary : SavoraColors.textPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: context.savoraText.headlineMedium?.copyWith(
                color: SavoraColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.dark_mode, color: SavoraColors.primary),
              title: Text('Theme Mode'),
              subtitle: Text(
                _themeMode == ThemeMode.system
                    ? 'System (${brightness == Brightness.dark ? "Dark" : "Light"})'
                    : _themeMode.name.capitalize(),
              ),
              trailing: DropdownButton<ThemeMode>(
                value: _themeMode,
                onChanged: (ThemeMode? newMode) {
                  if (newMode != null) {
                    setState(() => _themeMode = newMode);
                    widget.onThemeChanged(newMode);
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('System'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Light'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Dark'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
