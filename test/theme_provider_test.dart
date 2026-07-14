import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentvyn_tenant/core/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeProvider', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    });

    test('toggles and persists dark mode', () async {
      final provider = ThemeProvider();
      await provider.loadTheme();

      expect(provider.themeMode, ThemeMode.light);
      expect(provider.isDarkMode, false);

      await provider.toggleTheme(true);

      expect(provider.themeMode, ThemeMode.dark);
      expect(provider.isDarkMode, true);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('isDarkMode'), true);
    });
  });
}
