import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeModeKey = 'isDarkMode';

class SettingsDatasource {
  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeModeKey, mode == ThemeMode.dark);
  }

  Future<ThemeMode?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(_themeModeKey);
    if (isDarkMode != null) {
      return isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }

    return null;
  }
}
