import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hafiz_app/core/app_export.dart';
import 'package:hafiz_app/core/errors/failures.dart';
import 'package:hafiz_app/data/datasource/surah/surah_remote_data_source.dart';
import 'package:hafiz_app/data/model/surah_response.dart';
import 'package:hafiz_app/data/repository/surah/surah_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixture/fixture_reader.dart';

class MockSurahDataSource extends Mock implements SurahRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  //sut
  late SurahRepositoryImpl surahRepositoryImpl;
  late MockSurahDataSource mockSurahDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockSurahDataSource = MockSurahDataSource();
    mockNetworkInfo = MockNetworkInfo();

    surahRepositoryImpl = SurahRepositoryImpl(
        surahRemoteDataSource: mockSurahDataSource,
        networkInfo: mockNetworkInfo);
  });

  test("make sure calling getSurah - isConnected - return success", () async {
    when(() => mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
    final responsePayload = json.decode(fixture('surah_response.json'));
    var chapterResponse = ChapterResponse.fromJson(responsePayload);

    when(() => mockSurahDataSource.getSurah("114"))
        .thenAnswer((_) => Future(() => chapterResponse));
    var result = await surahRepositoryImpl.getSurah("114");
    expect(result, Right(chapterResponse));
  });

  test("make sure calling getSurah - isConnected - return failure", () async {
    when(() => mockNetworkInfo.isConnected()).thenAnswer((_) async => true);

    when(() => mockSurahDataSource.getSurah("114")).thenThrow(
        DioException(requestOptions: RequestOptions(), error: "Unknown Error"));

    var result = await surahRepositoryImpl.getSurah("114");
    verify(() => mockSurahDataSource.getSurah("114"));
    expect(result, Left(ServerFailure("Unknown Error")));
  });

  test("make sure calling getSurah - isNotConnected - return ConnectionFailure",
      () async {
    when(() => mockNetworkInfo.isConnected()).thenAnswer((_) async => false);

    var result = await surahRepositoryImpl.getSurah("114");
    expect(result, Left(ConnectionFailure()));
  });
}
