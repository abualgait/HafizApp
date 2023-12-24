import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../core/utils/navigator_service.dart';
import 'ar_eg/ar_eg_translations.dart';
import 'en_us/en_us_translations.dart';

class AppLocalization {
  AppLocalization(this.locale);

  Locale locale;

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': enUs,
    'ar': arEg
  };

  static AppLocalization of() {
    return Localizations.of<AppLocalization>(
        NavigatorService.navigatorKey.currentContext!, AppLocalization)!;
  }

  static List<String> languages() => _localizedValues.keys.toList();

  String getString(String text) =>
      _localizedValues[locale.languageCode]![text] ?? text;

  void setLocale(Locale newLocale) {
    locale = newLocale;
  }

  Locale getCurrentLocale() {
    return locale;
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalization.languages().contains(locale.languageCode);

  //Returning a SynchronousFuture here because an async "load" operation
  //cause an async "load" operation
  @override
  Future<AppLocalization> load(Locale locale) {
    return SynchronousFuture<AppLocalization>(AppLocalization(locale));
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}

extension LocalizationExtension on String {
  String get tr => AppLocalization.of().getString(this);
}
