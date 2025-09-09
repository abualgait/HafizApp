import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

class AnalyticsService {
  FirebaseAnalytics? get _analytics {
    try {
      // Avoid accessing Firebase before initialization
      if (Firebase.apps.isEmpty) return null;
      return FirebaseAnalytics.instance;
    } catch (_) {
      return null;
    }
  }

  final Map<String, DateTime> _screenEnter = {};

  Future<void> logScreenView({required String name, String? className}) async {
    final a = _analytics;
    if (a == null) return;
    await a.logScreenView(screenName: name, screenClass: className);
  }

  void startScreenTimer(String name) {
    _screenEnter[name] = DateTime.now();
  }

  Future<void> endScreenTimer(String name) async {
    final start = _screenEnter.remove(name);
    if (start != null) {
      final ms = DateTime.now().difference(start).inMilliseconds;
      final a = _analytics;
      if (a == null) return;
      await a.logEvent(name: 'screen_time', parameters: {
        'screen_name': name,
        'duration_ms': ms,
      });
    }
  }

  Future<void> logLanguageChange(String code) async {
    final a = _analytics;
    if (a == null) return;
    await a.logEvent(name: 'language_change', parameters: {
      'code': code,
    });
  }

  Future<void> logThemeChange(bool isDark) async {
    final a = _analytics;
    if (a == null) return;
    await a.logEvent(name: 'theme_toggle', parameters: {
      // Firebase Analytics only supports String or num parameter values
      'is_dark': isDark ? 1 : 0,
    });
  }

  Future<void> logContinueReading(int surahId, double? offset) async {
    final a = _analytics;
    if (a == null) return;
    await a.logEvent(name: 'continue_reading', parameters: {
      'surah_id': surahId,
      if (offset != null) 'offset': offset,
    });
  }

  Future<void> logOpenSurah(int surahId) async {
    final a = _analytics;
    if (a == null) return;
    await a.logEvent(name: 'open_surah', parameters: {
      'surah_id': surahId,
    });
  }

  Future<void> logLinkOpened(String url) async {
    final a = _analytics;
    if (a == null) return;
    await a.logEvent(name: 'open_link', parameters: {
      'url': url,
    });
  }

  Future<void> logFeedbackSubmitted({required String method}) async {
    final a = _analytics;
    if (a == null) return;
    await a.logEvent(name: 'feedback_submitted', parameters: {
      'method': method,
    });
  }
}
