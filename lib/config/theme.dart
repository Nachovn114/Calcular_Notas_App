import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Constantes de diseño
  static const double borderRadius = 16.0;
  static const double spacing = 8.0;
  static const EdgeInsets pagePadding = EdgeInsets.all(16.0);

  // Colores principales
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color secondaryColor = Color(0xFF2196F3);
  static const Color backgroundColor = Color(0xFFF5F5F5);

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
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundColor,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );

  // Tema Oscuro
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      background: Colors.grey[900]!,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );

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
