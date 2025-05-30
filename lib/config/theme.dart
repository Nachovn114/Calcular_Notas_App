import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Constantes de diseño
  static const double borderRadius = 16.0;
  static const double spacing = 8.0;
  static const EdgeInsets pagePadding = EdgeInsets.all(16.0);

  // Colores principales
  static const Color primaryLight = Color(0xFF6B4EFF);
  static const Color primaryDark = Color(0xFF8B6FFF);
  static const Color secondaryLight = Color(0xFF00D1B2);
  static const Color secondaryDark = Color(0xFF00F7D4);

  // Colores de estado
  static const Color successLight = Color(0xFF23D160);
  static const Color successDark = Color(0xFF00E676);
  static const Color warningLight = Color(0xFFFFDD57);
  static const Color warningDark = Color(0xFFFFE082);
  static const Color dangerLight = Color(0xFFFF3860);
  static const Color dangerDark = Color(0xFFFF5252);

  // Colores de fondo
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Tema Claro
  static ThemeData light() {
    final theme = ThemeData.light(useMaterial3: true);
    return theme.copyWith(
      colorScheme: ColorScheme.light(
        primary: primaryLight,
        secondary: secondaryLight,
        surface: surfaceLight,
        background: backgroundLight,
      ),
      scaffoldBackgroundColor: backgroundLight,
      cardTheme: theme.cardTheme.copyWith(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      appBarTheme: theme.appBarTheme.copyWith(
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(borderRadius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: primaryLight, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryLight,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  // Tema Oscuro
  static ThemeData dark() {
    final theme = ThemeData.dark(useMaterial3: true);
    return theme.copyWith(
      colorScheme: ColorScheme.dark(
        primary: primaryDark,
        secondary: secondaryDark,
        surface: surfaceDark,
        background: backgroundDark,
      ),
      scaffoldBackgroundColor: backgroundDark,
      cardTheme: theme.cardTheme.copyWith(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: surfaceDark,
      ),
      appBarTheme: theme.appBarTheme.copyWith(
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(borderRadius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: primaryDark, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryDark,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  // Decoraciones comunes
  static BoxDecoration get gradientBackground => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A73E8),
            Color(0xFF6C92F4),
          ],
        ),
      );

  static BoxDecoration get darkGradientBackground => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade900,
            Colors.grey.shade800,
          ],
        ),
      );

  // Utilidades de color para notas
  static Color getNotaColor(double nota) {
    if (nota >= 6.0) return successLight;
    if (nota >= 5.0) return const Color(0xFF00B8D4); // Cyan
    if (nota >= 4.0) return warningLight;
    return dangerLight;
  }

  static Color getNotaColorDark(double nota) {
    if (nota >= 6.0) return successDark;
    if (nota >= 5.0) return const Color(0xFF00E5FF); // Cyan
    if (nota >= 4.0) return warningDark;
    return dangerDark;
  }
}
