import 'dart:io';

import 'package:hafiz_app/core/network/network_manager.dart';

import '../../model/surah_response.dart';

abstract class SurahRemoteDataSource {
  Future<ChapterResponse> getSurah(String surahId);
}

class SurahRemoteDataSourceImpl implements SurahRemoteDataSource {
  final NetworkManagerImpl networkManager;

  SurahRemoteDataSourceImpl({
    required this.networkManager,
  });

  @override
  Future<ChapterResponse> getSurah(String surahId) async {
    var response =
        await networkManager.get('/editions/ara-quranuthmanihaf/$surahId.json');

    if (response.statusCode == 200) {
      return ChapterResponse.fromJson(response.data);
    } else {
      throw HttpException;
    }
  }
}
