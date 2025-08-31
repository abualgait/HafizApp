import 'package:flutter/material.dart';
import '../utils/pref_utils.dart';

class LocaleController {
  static final ValueNotifier<Locale> notifier =
      ValueNotifier<Locale>(_initialLocale());

  static Locale _initialLocale() {
    final code = PrefUtils().getLocaleCode();
    switch (code) {
      case 'en':
        return const Locale('en', 'US');
      case 'ar':
      default:
        return const Locale('ar', 'EG');
    }
  }

  static void setLocale(Locale locale) {
    notifier.value = locale;
    PrefUtils().setLocaleCode(locale.languageCode);
  }
}

