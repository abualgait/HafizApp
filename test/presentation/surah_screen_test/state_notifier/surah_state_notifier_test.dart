import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hafiz_app/core/errors/failures.dart';
import 'package:hafiz_app/data/model/surah_response.dart';
import 'package:hafiz_app/domain/usecase/getsurah/get_surah.dart';
import 'package:hafiz_app/presentation/surah_screen/provider/surah_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockGetSurah extends Mock implements GetSurah {}

void main() {
  late MockGetSurah mockGetSurah;
  late SurahStateNotifier surahStateNotifier;

  setUp(() {
    mockGetSurah = MockGetSurah();
    surahStateNotifier = SurahStateNotifier(getSurah: mockGetSurah);
  });

  tearDown(() => surahStateNotifier.dispose());

  group('SurahProvider Tests', () {
    test('LoadSurah success should update UI states', () async {
      var chapters = [Chapter(chapter: 114, verse: 1, text: "")];
      when(() => mockGetSurah(const ParamsGetSurah(surahId: "114"))).thenAnswer(
          (_) async => Right(ChapterResponse(chapters: chapters, id: "114")));

      // Act
      surahStateNotifier.loadSurah("114");

      // Allow time for the asynchronous operation to complete
      await Future.delayed(Duration.zero);

      // Assert
      expect(surahStateNotifier.state.isLoading, false);
      expect(surahStateNotifier.state.chapters.length, 1);
      expect(surahStateNotifier.state.error, '');
    });

    test('LoadSurah fail should update UI states with server error', () async {
      when(() => mockGetSurah(const ParamsGetSurah(surahId: "-1")))
          .thenAnswer((_) async => Left(ServerFailure("server error")));

      // Act
      surahStateNotifier.loadSurah("-1");

      // Allow time for the asynchronous operation to complete
      await Future.delayed(Duration.zero);

      // Assert
      expect(surahStateNotifier.state.isLoading, false);
      expect(surahStateNotifier.state.chapters.length, 0);
      expect(surahStateNotifier.state.error, 'server error');
    });

    test('LoadSurah fail should update UI states with connection error',
        () async {
      when(() => mockGetSurah(const ParamsGetSurah(surahId: "-2")))
          .thenAnswer((_) async => Left(ConnectionFailure()));
      // Act
      surahStateNotifier.loadSurah("-2");

      // Allow time for the asynchronous operation to complete
      await Future.delayed(Duration.zero);

      // Assert
      expect(surahStateNotifier.state.isLoading, false);
      expect(surahStateNotifier.state.chapters.length, 0);
      expect(surahStateNotifier.state.error, messageConnectionFailure);
    });
  });
}
