import 'package:flutter/material.dart';

extension ThemeUtils on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  Size get mediaQuerySize => MediaQuery.sizeOf(this);
}

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const _regular = FontWeight.w400;
const _medium = FontWeight.w500;
const _semiBold = FontWeight.w600;
const _bold = FontWeight.w700;

const TextTheme _textTheme = TextTheme(
  displayLarge: TextStyle(fontWeight: _bold, fontSize: 40.0),
  displayMedium: TextStyle(fontWeight: _bold, fontSize: 32.0),
  displaySmall: TextStyle(fontWeight: _medium, fontSize: 28.0),
  headlineLarge: TextStyle(fontWeight: _bold, fontSize: 22.0),
  headlineMedium: TextStyle(fontWeight: _bold, fontSize: 20.0),
  headlineSmall: TextStyle(fontWeight: _medium, fontSize: 16.0),
  titleLarge: TextStyle(fontWeight: _bold, fontSize: 16.0),
  titleMedium: TextStyle(fontWeight: _medium, fontSize: 16.0),
  titleSmall: TextStyle(fontWeight: _medium, fontSize: 14.0),
  bodyLarge: TextStyle(fontWeight: _regular, fontSize: 14.0),
  bodyMedium: TextStyle(fontWeight: _regular, fontSize: 16.0),
  bodySmall: TextStyle(fontWeight: _semiBold, fontSize: 16.0),
  labelLarge: TextStyle(fontWeight: _semiBold, fontSize: 14.0),
  labelMedium: TextStyle(fontWeight: _semiBold, fontSize: 13.0),
  labelSmall: TextStyle(fontWeight: _medium, fontSize: 12.0),
);

ThemeData lightThemeData() {
  return ThemeData.light().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    iconTheme: const IconThemeData(color: kContentColorLightTheme),
    textTheme: _textTheme.apply(
      bodyColor: kContentColorLightTheme,
      displayColor: kContentColorLightTheme,
    ),
    colorScheme: const ColorScheme.light(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: kContentColorLightTheme.withOpacity(0.7),
      unselectedItemColor: kContentColorLightTheme.withOpacity(0.32),
      selectedIconTheme: const IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}

ThemeData darkThemeData() {
  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kContentColorLightTheme,
    appBarTheme: AppBarTheme(backgroundColor: kContentColorLightTheme),
    iconTheme: const IconThemeData(color: kContentColorDarkTheme),
    textTheme: _textTheme.apply(
      bodyColor: kContentColorDarkTheme,
      displayColor: kContentColorDarkTheme,
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kContentColorLightTheme,
      selectedItemColor: Colors.white70,
      unselectedItemColor: kContentColorDarkTheme.withOpacity(0.32),
      selectedIconTheme: const IconThemeData(color: kPrimaryColor),
      showUnselectedLabels: true,
    ),
  );
}
