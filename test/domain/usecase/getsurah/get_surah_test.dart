import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hafiz_app/core/errors/failures.dart';
import 'package:hafiz_app/data/model/surah_response.dart';
import 'package:hafiz_app/domain/repository/surah/surah_repository.dart';
import 'package:hafiz_app/domain/usecase/getsurah/get_surah.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixture/fixture_reader.dart';

class MockSurahRepo extends Mock implements SurahRepository {}

void main() {
  late GetSurah getSurah;
  late MockSurahRepo mockSurahRepo;
  setUp(() {
    mockSurahRepo = MockSurahRepo();
    getSurah = GetSurah(surahRepository: mockSurahRepo);
  });

  test("make sure get_surah return success", () async {
    var surahResponse =
        ChapterResponse.fromJson(json.decode(fixture("surah_response.json")));

    when(() => mockSurahRepo.getSurah("114"))
        .thenAnswer((_) async => Right(surahResponse));

    var result = await getSurah.call(const ParamsGetSurah(surahId: "114"));
    expect(result, Right(surahResponse));
    verify(() => mockSurahRepo.getSurah("114"));
  });

  test("make sure get_surah return failure", () async {

    when(() => mockSurahRepo.getSurah("114"))
        .thenAnswer((_) async => Left(ServerFailure("error")));

    var result = await getSurah.call(const ParamsGetSurah(surahId: "114"));
    expect(result, Left(ServerFailure("error")));
    verify(() => mockSurahRepo.getSurah("114"));
  });
}
