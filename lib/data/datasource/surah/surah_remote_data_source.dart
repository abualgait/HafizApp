import 'dart:async';
import 'package:dio/dio.dart';
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
    // Quran.com API v4: verses by chapter with Uthmani text
    // Docs: https://api.quran.com/api/v4/
    const int maxAttempts = 3;
    Response? response;
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final r = await networkManager.get(
          '/verses/by_chapter/$surahId',
          params: {
            'per_page': 300,
            'words': 'false',
            'fields': 'chapter_id,verse_key,text_uthmani',
          },
        );
        response = r;
        // If 5xx/429, backoff and retry (except last attempt)
        final status = r.statusCode ?? 0;
        if (status == 200) {
          break; // success
        }
        if ((status >= 500 || status == 429) && attempt < maxAttempts) {
          // simple exponential-ish backoff
          await Future.delayed(Duration(milliseconds: 200 * attempt * attempt));
          continue;
        }
        // Non-retryable status; fall through to error throw after loop
        break;
      } on DioException catch (e) {
        // Retry on network-level errors (connect timeout, receive timeout, etc.)
        if (attempt < maxAttempts &&
            (e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionError)) {
          await Future.delayed(Duration(milliseconds: 200 * attempt * attempt));
          continue;
        }
        rethrow; // non-retryable Dio errors
      }
    }

    if (response != null && response.statusCode == 200) {
      final data = response!.data;
      // Support both legacy shape {"chapter": [...]} and Quran.com {"verses": [...]}
      if (data is Map && data.containsKey('chapter')) {
        return ChapterResponse.fromJson(
            Map<String, dynamic>.from(data));
      }

      final verses = (data['verses'] as List<dynamic>?) ?? const [];
      final chapters = verses.map((v) {
        final m = v as Map<String, dynamic>;
        final verseNumber = m['verse_number'] as int? ??
            int.tryParse(((m['verse_key'] as String?) ?? '0:0').split(':').last) ??
            0;
        return Chapter(
          chapter: (m['chapter_id'] as num?)?.toInt() ?? int.parse(surahId),
          verse: verseNumber,
          text: (m['text_uthmani'] as String?) ?? '',
        );
      }).toList();
      return ChapterResponse(chapters: chapters);
    } else {
      throw DioException(
        requestOptions: response?.requestOptions ?? RequestOptions(path: '/verses/by_chapter/$surahId'),
        response: response,
        error: 'Unexpected status code: ${response?.statusCode}',
        type: DioExceptionType.badResponse,
      );
    }
  }
}
