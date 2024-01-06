import 'package:hafiz_app/core/local/DatabaseHelper.dart';

import '../../model/surah_response.dart';

abstract class SurahLocalDataSource {
  Future<ChapterResponse?> getSurahById(String surahId);

  Future<int> insertSurah(ChapterResponse chapterResponse);
}

class SurahLocalDataSourceImpl implements SurahLocalDataSource {
  final DatabaseHelper databaseHelper;

  SurahLocalDataSourceImpl({
    required this.databaseHelper,
  });

  @override
  Future<ChapterResponse?> getSurahById(String surahId) {
    return databaseHelper.queryDataById(surahId);
  }

  @override
  Future<int> insertSurah(ChapterResponse chapterResponse) {
    return databaseHelper.insertData(chapterResponse);
  }
}
