import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../model/surah_response.dart';

abstract class SurahLocalDataSource {
  Future<ChapterResponse> getSurah(String surahId);
}

class SurahLocalDataSourceImpl implements SurahLocalDataSource {
  final String basePath;

  SurahLocalDataSourceImpl({this.basePath = 'assets/quran/uthmani'});

  @override
  Future<ChapterResponse> getSurah(String surahId) async {
    final path = '$basePath/surah_$surahId.json';
    final jsonStr = await rootBundle.loadString(path);
    final Map<String, dynamic> data = json.decode(jsonStr);
    return ChapterResponse.fromJson(data);
  }
}

