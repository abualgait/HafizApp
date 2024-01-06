import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hafiz_app/data/datasource/surah/surah_local_data_source.dart';

import '../../../core/errors/failures.dart';
import '../../../core/network/network_info.dart';
import '../../../domain/repository/surah/surah_repository.dart';
import '../../datasource/surah/surah_remote_data_source.dart';
import '../../model/surah_response.dart';

class SurahRepositoryImpl implements SurahRepository {
  final SurahRemoteDataSource surahRemoteDataSource;
  final SurahLocalDataSource surahLocalDataSource;
  final NetworkInfo networkInfo;

  SurahRepositoryImpl({
    required this.surahRemoteDataSource,
    required this.surahLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ChapterResponse>> getSurah(String surahId) async {
    var result = await surahLocalDataSource.getSurahById(surahId);
    if (result != null) {
      return Right(result);
    }
    bool isConnected = await networkInfo.isConnected();
    if (isConnected) {
      try {
        var response = await surahRemoteDataSource.getSurah(surahId);
        surahLocalDataSource.insertSurah(response);
        return Right(response);
      } on DioException catch (error) {
        return Left(ServerFailure(error.message ?? "Unknown Error"));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
