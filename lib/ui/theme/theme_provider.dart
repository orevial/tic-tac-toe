import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe/data/settings_datasource.dart';

final themeProvider = AsyncNotifierProvider<ThemeNotifier, ThemeMode?>(
  ThemeNotifier.new,
);

class ThemeNotifier extends AsyncNotifier<ThemeMode?> {
  // TODO Decouple with DI
  final SettingsDatasource _settingsDatasource = SettingsDatasource();

  @override
  Future<ThemeMode?> build() {
    return _settingsDatasource.getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = AsyncData(mode);
    await _settingsDatasource.saveThemeMode(mode);
  }
}
