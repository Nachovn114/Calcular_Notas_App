import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  late final SharedPreferences _prefs;
  late ThemeMode _themeMode;
  bool _isInitialized = false;

  ThemeProvider() {
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    _prefs = await SharedPreferences.getInstance();
    final savedTheme = _prefs.getString(_themeKey);
    _themeMode = savedTheme != null
        ? ThemeMode.values.firstWhere(
            (mode) => mode.toString() == savedTheme,
            orElse: () => ThemeMode.system,
          )
        : ThemeMode.system;
    _isInitialized = true;
    notifyListeners();
  }

  ThemeMode get themeMode => _isInitialized ? _themeMode : ThemeMode.system;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> setThemeMode(ThemeMode mode) async {
    if (!_isInitialized || _themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    await _prefs.setString(_themeKey, mode.toString());
  }

  void toggleTheme() {
    setThemeMode(
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}
