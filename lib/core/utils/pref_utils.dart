//ignore: unused_import
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hafiz_app/core/quran_index/quran_surah.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _sharedPreferences;

  PrefUtils() {
    // init();
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    debugPrint('SharedPreference Initialized');
  }

  ///will clear all the data stored in preference
  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

  Future<void> setIsDarkMode(bool value) {
    return _sharedPreferences!.setBool('isDarkTheme', value);
  }

  bool getIsDarkMode() {
    try {
      return _sharedPreferences!.getBool('isDarkTheme')!;
    } catch (e) {
      return false;
    }
  }

  // Convert Surah object to JSON string
  String toJson(Surah surah) => json.encode(surah.toMap());

  // Store Surah object in SharedPreferences
  Future<void> saveLastReadSurah(Surah surah) async {
    await _sharedPreferences!.setString('surah', toJson(surah));
  }

  // Retrieve Surah object from SharedPreferences
  Surah? getLastReadSurah() {
    final String? jsonString = _sharedPreferences!.getString('surah');
    return jsonString != null ? Surah.fromJson(jsonString) : null;
  }
}
