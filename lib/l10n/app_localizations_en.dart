// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Tic Tac Toe';

  @override
  String get appCatchphrase => 'Three in a row... or more !';

  @override
  String get startGameInstruction =>
      'Choose your grid size and your difficulty and start a game to beat the AI!';

  @override
  String get startGameGridSizeLabel => 'Grid size:';

  @override
  String get startGameStartButton => 'Start';

  @override
  String get startGameDifficultyLabel => 'Difficulty:';

  @override
  String get startGameDifficultyEasyLabel => 'Easy';

  @override
  String get startGameDifficultyHardLabel => 'Hard';

  @override
  String get statsLabel => 'Stats';

  @override
  String statWins(int n, int percentage) {
    return 'Wins : $n ($percentage%)';
  }

  @override
  String statLoses(int n, int percentage) {
    return 'Loses : $n ($percentage%)';
  }

  @override
  String statDraws(int n, int percentage) {
    return 'Draws : $n ($percentage%)';
  }

  @override
  String get boardHumanPlayerTurn => 'Your turn !';

  @override
  String get boardAiPlayerTurn => 'It\'s the AI\'s turn...';

  @override
  String get boardPlayAgainButtonLabel => 'Play again';

  @override
  String get boardVictoryTitle => 'Congrats !!';

  @override
  String get boardVictoryText => 'You won!';

  @override
  String get boardDefeatTitle => 'Oops!';

  @override
  String get boardDefeatText => 'You lost...';

  @override
  String get boardDrawTitle => 'Oops!';

  @override
  String get boardDrawText => 'It\'s a draw...';
}
