import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hafiz_app/core/network/network_manager.dart';
import 'package:hafiz_app/data/datasource/surah/surah_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';

import '../../../fixture/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late SurahRemoteDataSourceImpl surahRemoteDataSource;
  late NetworkManagerImpl networkManagerImpl;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    mockDio.options = BaseOptions(
        baseUrl: "https://cdn.jsdelivr.net/gh/fawazahmed0/quran-api@1");
    networkManagerImpl = NetworkManagerImpl(mockDio);
    surahRemoteDataSource =
        SurahRemoteDataSourceImpl(networkManager: networkManagerImpl);
  });

  group("Make sure data source ", () {
    void setUpMockDioSuccess() {
      final responsePayload = json.decode(fixture('surah_response.json'));
      final response = Response(
        data: responsePayload,
        statusCode: 200,
        requestOptions: RequestOptions(baseUrl: ""),
      );
      when(
        () => mockDio.get("/editions/ara-quranuthmanihaf/114.json"),
      ).thenAnswer((_) async => response);
    }

    void setUpMockDioFailed() {
      final response = Response(
        data: "{}",
        statusCode: 400,
        requestOptions: RequestOptions(baseUrl: ""),
      );
      when(
        () => mockDio.get("/editions/ara-quranuthmanihaf/114.json"),
      ).thenAnswer((_) async => response);
    }

    test("make sure get surah return success", () async {
      setUpMockDioSuccess();
      var result = await surahRemoteDataSource.getSurah("114");
      expect(result.chapters.length, 6);
      expect(result.chapters.first.verse, 1);
      verify(() => mockDio.get("/editions/ara-quranuthmanihaf/114.json"));
    });

    test("make sure get surah return failure", () async {
      setUpMockDioFailed();
      var result = await surahRemoteDataSource.getSurah("114");
      expect(() => result, throwsA(const TypeMatcher<DioException>()));
    });
  });
}
