import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    colorSchemeSeed: Colors.indigo,
    brightness: Brightness.light,
    useMaterial3: true,
  );

  static final darkTheme = ThemeData(
    colorSchemeSeed: Colors.deepPurple,
    brightness: Brightness.dark,
    useMaterial3: true,
  );
}
