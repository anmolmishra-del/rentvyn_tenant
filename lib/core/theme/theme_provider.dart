import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    loadTheme();
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);

    notifyListeners();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool('isDarkMode');
    if (isDark == null) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    }

    notifyListeners();
  }
}