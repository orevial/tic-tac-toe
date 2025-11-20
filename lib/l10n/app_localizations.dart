import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Tic Tac Toe'**
  String get appName;

  /// No description provided for @appCatchphrase.
  ///
  /// In en, this message translates to:
  /// **'Three in a row... or more !'**
  String get appCatchphrase;

  /// No description provided for @startGameInstruction.
  ///
  /// In en, this message translates to:
  /// **'Choose your grid size and your difficulty and start a game to beat the AI!'**
  String get startGameInstruction;

  /// No description provided for @startGameGridSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Grid size:'**
  String get startGameGridSizeLabel;

  /// No description provided for @startGameStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startGameStartButton;

  /// No description provided for @startGameDifficultyLabel.
  ///
  /// In en, this message translates to:
  /// **'Difficulty:'**
  String get startGameDifficultyLabel;

  /// No description provided for @startGameDifficultyEasyLabel.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get startGameDifficultyEasyLabel;

  /// No description provided for @startGameDifficultyHardLabel.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get startGameDifficultyHardLabel;

  /// No description provided for @boardHumanPlayerTurn.
  ///
  /// In en, this message translates to:
  /// **'Your turn !'**
  String get boardHumanPlayerTurn;

  /// No description provided for @boardAiPlayerTurn.
  ///
  /// In en, this message translates to:
  /// **'It\'s the AI\'s turn...'**
  String get boardAiPlayerTurn;

  /// No description provided for @boardPlayAgainButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get boardPlayAgainButtonLabel;

  /// No description provided for @boardVictoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Congrats !!'**
  String get boardVictoryTitle;

  /// No description provided for @boardVictoryText.
  ///
  /// In en, this message translates to:
  /// **'You won!'**
  String get boardVictoryText;

  /// No description provided for @boardDefeatTitle.
  ///
  /// In en, this message translates to:
  /// **'Oops!'**
  String get boardDefeatTitle;

  /// No description provided for @boardDefeatText.
  ///
  /// In en, this message translates to:
  /// **'You lost...'**
  String get boardDefeatText;

  /// No description provided for @boardDrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Oops!'**
  String get boardDrawTitle;

  /// No description provided for @boardDrawText.
  ///
  /// In en, this message translates to:
  /// **'It\'s a draw...'**
  String get boardDrawText;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
