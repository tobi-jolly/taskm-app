import 'package:flutter/material.dart';
import '../services/shared_pref_service.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() async {
    _isDarkTheme = await SharedPrefService.getTheme();
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;
    await SharedPrefService.setDarkTheme(_isDarkTheme);
    notifyListeners();
  }
}
