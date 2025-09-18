import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isDarkMode = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeMode = prefs.getString(AppConstants.themeKey) ?? 'system';
      
      switch (savedThemeMode) {
        case 'light':
          _themeMode = ThemeMode.light;
          _isDarkMode = false;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          _isDarkMode = true;
          break;
        default:
          _themeMode = ThemeMode.system;
          _isDarkMode = _getSystemBrightness() == Brightness.dark;
      }
      
      notifyListeners();
    } catch (e) {
      // Handle error - use default theme
      _themeMode = ThemeMode.system;
      _isDarkMode = _getSystemBrightness() == Brightness.dark;
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      _themeMode = mode;
      
      switch (mode) {
        case ThemeMode.light:
          _isDarkMode = false;
          break;
        case ThemeMode.dark:
          _isDarkMode = true;
          break;
        case ThemeMode.system:
          _isDarkMode = _getSystemBrightness() == Brightness.dark;
          break;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.themeKey, mode.name);
      
      notifyListeners();
    } catch (e) {
      // Handle error - log if needed
      // print('Error saving theme mode: $e');
    }
  }

  Future<void> toggleTheme() async {
    final newMode = _isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  Brightness _getSystemBrightness() {
    return WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }

  void updateSystemBrightness() {
    if (_themeMode == ThemeMode.system) {
      final newBrightness = _getSystemBrightness();
      final newIsDarkMode = newBrightness == Brightness.dark;
      
      if (_isDarkMode != newIsDarkMode) {
        _isDarkMode = newIsDarkMode;
        notifyListeners();
      }
    }
  }
}
