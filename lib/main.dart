import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictactoe/l10n/app_localizations.dart';
import 'package:tictactoe/ui/start_screen.dart';
import 'package:tictactoe/ui/theme/theme.dart';
import 'package:tictactoe/ui/theme/theme_provider.dart';

void main() {
  runApp(ProviderScope(child: const TicTacToeApp()));
}

class TicTacToeApp extends ConsumerWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncThemeMode = ref.watch(themeProvider);
    final themeMode = switch (asyncThemeMode) {
      AsyncValue(:final value?) => value,
      _ => null,
    };

    return MaterialApp(
      themeMode: themeMode,
      theme: lightThemeData(),
      darkTheme: darkThemeData(),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: StartScreen(),
    );
  }
}
