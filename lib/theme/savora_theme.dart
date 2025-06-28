import 'package:flutter/material.dart';

class SavoraColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF00D4AA);     // Modern teal-green
  static const Color secondary = Color(0xFF6366F1);   // Indigo
  static const Color accent = Color(0xFFFF6B35);      // Energetic orange
  
  // Financial Colors
  static const Color success = Color(0xFF10B981);     // Green for gains
  static const Color warning = Color(0xFFF59E0B);     // Amber for warnings
  static const Color danger = Color(0xFFEF4444);      // Red for losses
  
  // Neutral Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  
  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  
  // Gradient Colors
  static const List<Color> primaryGradient = [primary, Color(0xFF00B4D8)];
  static const List<Color> secondaryGradient = [secondary, Color(0xFF8B5CF6)];
  static const List<Color> accentGradient = [accent, Color(0xFFFF8A65)];
  
  // Game-specific Colors
  static const Color xpColor = Color(0xFFFFD700);     // Gold for XP
  static const Color streakColor = Color(0xFFFF6B35); // Orange for streaks
  static const Color levelColor = Color(0xFF00D4AA);  // Teal for levels
}

class SavoraTheme {
  static ThemeData get lightTheme {
    return ThemeData.light(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.light(
        primary: SavoraColors.primary,
        secondary: SavoraColors.secondary,
        tertiary: SavoraColors.accent,
        surface: SavoraColors.surface,
        background: SavoraColors.background,
        error: SavoraColors.danger,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onSurface: SavoraColors.textPrimary,
        onBackground: SavoraColors.textPrimary,
        onError: Colors.white,
      ),
      textTheme: _buildTextTheme(SavoraColors.textPrimary, SavoraColors.textSecondary),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: SavoraColors.surface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SavoraColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SavoraColors.primary,
          side: const BorderSide(color: SavoraColors.primary, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SavoraColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SavoraColors.textSecondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SavoraColors.textSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SavoraColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: SavoraColors.surface,
        foregroundColor: SavoraColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: SavoraColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: SavoraColors.surface,
        selectedItemColor: SavoraColors.primary,
        unselectedItemColor: SavoraColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: SavoraColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.dark(
        primary: SavoraColors.primary,
        secondary: SavoraColors.secondary,
        tertiary: SavoraColors.accent,
        surface: SavoraColors.darkSurface,
        background: SavoraColors.darkBackground,
        error: SavoraColors.danger,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
        onSurface: SavoraColors.darkTextPrimary,
        onBackground: SavoraColors.darkTextPrimary,
        onError: Colors.white,
      ),
      textTheme: _buildTextTheme(SavoraColors.darkTextPrimary, SavoraColors.darkTextSecondary),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: SavoraColors.darkSurface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SavoraColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SavoraColors.primary,
          side: const BorderSide(color: SavoraColors.primary, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SavoraColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SavoraColors.darkTextSecondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SavoraColors.darkTextSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SavoraColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: SavoraColors.darkSurface,
        foregroundColor: SavoraColors.darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: SavoraColors.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: SavoraColors.darkSurface,
        selectedItemColor: SavoraColors.primary,
        unselectedItemColor: SavoraColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: SavoraColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  static TextTheme _buildTextTheme(Color primaryColor, Color secondaryColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: primaryColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: primaryColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: primaryColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: secondaryColor,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryColor,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
    );
  }
}

// Extension for easy theme access
extension SavoraThemeExtension on BuildContext {
  ColorScheme get savoraColors => Theme.of(this).colorScheme;
  TextTheme get savoraText => Theme.of(this).textTheme;
} 