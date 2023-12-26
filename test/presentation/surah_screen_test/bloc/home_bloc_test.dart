import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hafiz_app/core/errors/failures.dart';
import 'package:hafiz_app/data/model/surah_response.dart';
import 'package:hafiz_app/domain/usecase/getsurah/get_surah.dart';
import 'package:hafiz_app/presentation/surah_screen/bloc/surah_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixture/fixture_reader.dart';

class MockGetSurah extends Mock implements GetSurah {}

void main() {
  late MockGetSurah mockGetSurah;
  late SurahBloc surahBloc;
  setUp(() {
    mockGetSurah = MockGetSurah();
    surahBloc = SurahBloc(getSurah: mockGetSurah);
    var surahResponse =
        ChapterResponse.fromJson(json.decode(fixture("surah_response.json")));

    when(() => mockGetSurah(const ParamsGetSurah(surahId: "114")))
        .thenAnswer((_) async => Right(surahResponse));

    when(() => mockGetSurah(const ParamsGetSurah(surahId: "-1")))
        .thenAnswer((_) async => Left(ServerFailure("server error")));

    when(() => mockGetSurah(const ParamsGetSurah(surahId: "-2")))
        .thenAnswer((_) async => Left(ConnectionFailure()));
  });

  tearDown(() => surahBloc.close());

  test("make sure initial state is SuccessSurahState", () async {
    expect(surahBloc.state, const SuccessSurahState(chapters: []));
  });

  group("SurahBloc Success", () {
    blocTest('emits [LoadingSurahState] when LoadSurahEvent is added',
        build: () => surahBloc,
        act: (bloc) => bloc.add(LoadSurahEvent(surahId: "114")),
        expect: () => [isA<LoadingSurahState>(), isA<SuccessSurahState>()],
        verify: (_) {
          verify(() => mockGetSurah(const ParamsGetSurah(surahId: "114")))
              .called(1);
        });
  });

  group("SurahBloc Failed", () {
    blocTest('emits [FailureSurahState] when LoadSurahEvent is added',
        build: () => surahBloc,
        act: (bloc) => bloc.add(LoadSurahEvent(surahId: "-1")),
        expect: () => [isA<LoadingSurahState>(), isA<FailureSurahState>()],
        verify: (_) {
          verify(() => mockGetSurah(const ParamsGetSurah(surahId: "-1")))
              .called(1);
        });
    blocTest('emits [ConnectionFailure] when LoadSurahEvent is added',
        build: () => surahBloc,
        act: (bloc) => bloc.add(LoadSurahEvent(surahId: "-2")),
        expect: () => [isA<LoadingSurahState>(), isA<FailureSurahState>()],
        verify: (_) {
          verify(() => mockGetSurah(const ParamsGetSurah(surahId: "-2")))
              .called(1);
        });
  });
}
