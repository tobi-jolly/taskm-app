import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  static const String themeKey = 'isDarkTheme';

  static Future<void> setDarkTheme(bool isDark) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeKey, isDark);
  }

  static Future<bool> getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeKey) ?? false;
  }
}
