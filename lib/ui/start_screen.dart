import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:tictactoe/domain/bot_difficulty.dart';
import 'package:tictactoe/domain/grid_size.dart';
import 'package:tictactoe/ui/theme/theme.dart';
import 'package:tictactoe/ui/theme/theme_provider.dart';
import 'package:tictactoe/ui/theme/theme_spacings.dart';
import 'package:tictactoe/ui/utils/extensions.dart';

import 'game_screen.dart';

class StartScreen extends ConsumerStatefulWidget {
  const StartScreen({super.key});

  @override
  ConsumerState<StartScreen> createState() => _StartPageState();
}

class _StartPageState extends ConsumerState<StartScreen> {
  GridSize _gridSize = GridSize.three;
  BotDifficulty _botDifficulty = BotDifficulty.easy;

  @override
  Widget build(BuildContext context) {
    final animationSize = context.mediaQuerySize.width / 2;

    return Scaffold(
      appBar: AppBar(actions: [ThemeModeIcon()]),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            width: .infinity,
            child: Column(
              crossAxisAlignment: .center,
              children: [
                Text(
                  context.l10n.appName,
                  style: context.textTheme.displayLarge,
                ),
                Space.xxs,
                Text(
                  context.l10n.appCatchphrase,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Space.l,
                Padding(
                  padding: const .symmetric(horizontal: ThemeSize.m),
                  child: Text(
                    context.l10n.startGameInstruction,
                    textAlign: .center,
                  ),
                ),
                Space.l,
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ThemeSize.m,
                      vertical: ThemeSize.sm,
                    ),
                    child: Column(
                      children: [
                        Text(context.l10n.startGameGridSizeLabel),
                        Space.xs,
                        SegmentedButton<GridSize>(
                          segments: GridSize.values
                              .map(
                                (size) => ButtonSegment<GridSize>(
                                  value: size,
                                  label: Text(size.size.toString()),
                                ),
                              )
                              .toList(),
                          selected: {_gridSize},
                          onSelectionChanged: (newSelection) {
                            setState(() {
                              _gridSize = newSelection.first;
                            });
                          },
                        ),
                        Space.sm,
                        Text(context.l10n.startGameDifficultyLabel),
                        Space.xs,
                        SegmentedButton<BotDifficulty>(
                          segments: BotDifficulty.values
                              .map(
                                (difficulty) => ButtonSegment<BotDifficulty>(
                                  value: difficulty,
                                  label: Text(difficulty.label(context)),
                                ),
                              )
                              .toList(),
                          selected: {_botDifficulty},
                          onSelectionChanged: (newSelection) {
                            setState(() {
                              _botDifficulty = newSelection.first;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Space.l,
                FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => GameScreen(
                          gridSize: _gridSize,
                          botDifficulty: _botDifficulty,
                        ),
                      ),
                    );
                  },
                  child: Text(context.l10n.startGameStartButton),
                ),
              ],
            ),
          ),
          Align(
            alignment: .bottomRight,
            child: Lottie.asset(
              'assets/animations/orange_skating.json',
              width: animationSize,
              height: animationSize,
            ),
          ),
        ],
      ),
    );
  }
}

class ThemeModeIcon extends ConsumerWidget {
  const ThemeModeIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncThemeMode = ref.watch(themeProvider);
    final themeMode = switch (asyncThemeMode) {
      AsyncValue(:final value?) => value,
      _ => _getDefaultThemeMode(context),
    };

    return IconButton.filledTonal(
      onPressed: () {
        ref
            .read(themeProvider.notifier)
            .setThemeMode(
              themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
            );
      },
      icon: Icon(
        themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
      ),
    );
  }

  ThemeMode _getDefaultThemeMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? ThemeMode.light
        : ThemeMode.dark;
  }
}

extension on BotDifficulty {
  String label(BuildContext context) => switch (this) {
    BotDifficulty.easy => context.l10n.startGameDifficultyEasyLabel,
    BotDifficulty.hard => context.l10n.startGameDifficultyHardLabel,
  };
}
