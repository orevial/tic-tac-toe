// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Morpion';

  @override
  String get appCatchphrase => 'Trois à la suite... ou plus !';

  @override
  String get startGameInstruction =>
      'Choisissez votre taille de grille et votre difficulté puis lancez le jeu pour vous mesurer à l\'IA !';

  @override
  String get startGameGridSizeLabel => 'Taille de grille :';

  @override
  String get startGameStartButton => 'Démarrer';

  @override
  String get startGameDifficultyLabel => 'Difficulté :';

  @override
  String get startGameDifficultyEasyLabel => 'Facile';

  @override
  String get startGameDifficultyHardLabel => 'Difficile';

  @override
  String get boardHumanPlayerTurn => 'À vous de jouer !';

  @override
  String get boardAiPlayerTurn => 'C\'est au tour de l\'IA...';

  @override
  String get boardPlayAgainButtonLabel => 'Rejouer';

  @override
  String get boardVictoryTitle => 'Bravo !!';

  @override
  String get boardVictoryText => 'Vous avez gagné !';

  @override
  String get boardDefeatTitle => 'Oups !';

  @override
  String get boardDefeatText => 'Vous avez perdu...';

  @override
  String get boardDrawTitle => 'Oups !';

  @override
  String get boardDrawText => 'C\'est une égalité...';
}
