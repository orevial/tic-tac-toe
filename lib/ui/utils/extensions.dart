import 'package:flutter/cupertino.dart';
import 'package:tictactoe/l10n/app_localizations.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
