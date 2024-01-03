import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hafiz_app/core/errors/failures.dart';
import 'package:hafiz_app/data/model/surah_response.dart';
import 'package:hafiz_app/domain/usecase/getsurah/get_surah.dart';
import 'package:hafiz_app/presentation/surah_screen/provider/surah_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockGetSurah extends Mock implements GetSurah {}

class MockObserver extends Mock implements Listenable {}

void main() {
  late MockGetSurah mockGetSurah;
  late SurahProvider surahProvider;

  setUp(() {
    mockGetSurah = MockGetSurah();
    surahProvider = SurahProvider(getSurah: mockGetSurah);
  });

  tearDown(() => surahProvider.dispose());

  group('SurahProvider Tests', () {
    test('LoadSurah success should update UI states', () async {
      var chapters = [Chapter(chapter: 114, verse: 1, text: "")];
      when(() => mockGetSurah(const ParamsGetSurah(surahId: "114")))
          .thenAnswer((_) async => Right(ChapterResponse(chapters: chapters)));

      // Act
      surahProvider.loadSurah("114");

      // Allow time for the asynchronous operation to complete
      await Future.delayed(Duration.zero);

      // Assert
      expect(surahProvider.surahStates?.isLoading, false);
      expect(surahProvider.surahStates?.chapters.length, 1);
      expect(surahProvider.surahStates?.error, '');
    });

    test('LoadSurah fail should update UI states with server error', () async {
      when(() => mockGetSurah(const ParamsGetSurah(surahId: "-1")))
          .thenAnswer((_) async => Left(ServerFailure("server error")));

      // Act
      surahProvider.loadSurah("-1");

      // Allow time for the asynchronous operation to complete
      await Future.delayed(Duration.zero);

      // Assert
      expect(surahProvider.surahStates?.isLoading, false);
      expect(surahProvider.surahStates?.chapters.length, 0);
      expect(surahProvider.surahStates?.error, 'server error');
    });

    test('LoadSurah fail should update UI states with connection error',
        () async {
      when(() => mockGetSurah(const ParamsGetSurah(surahId: "-2")))
          .thenAnswer((_) async => Left(ConnectionFailure()));
      // Act
      surahProvider.loadSurah("-2");

      // Allow time for the asynchronous operation to complete
      await Future.delayed(Duration.zero);

      // Assert
      expect(surahProvider.surahStates?.isLoading, false);
      expect(surahProvider.surahStates?.chapters.length, 0);
      expect(surahProvider.surahStates?.error, messageConnectionFailure);
    });
  });
}
