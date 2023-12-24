import 'dart:io';

import 'package:dio/dio.dart';

import '../../model/surah_response.dart';

abstract class SurahRemoteDataSource {
  Future<ChapterResponse> getSurah(String surahId);
}

class SurahRemoteDataSourceImpl implements SurahRemoteDataSource {
  final Dio dio;

  SurahRemoteDataSourceImpl({
    required this.dio,
  });

  @override
  Future<ChapterResponse> getSurah(String surahId) async {
    var response = await dio.get('/editions/ara-quranuthmanihaf/$surahId.json');

    if (response.statusCode == 200) {
      return ChapterResponse.fromJson(response.data);
    } else {
      throw HttpException;
    }
  }
}
