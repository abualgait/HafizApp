import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hafiz_app/core/app_export.dart';
import 'package:hafiz_app/core/local/DatabaseHelper.dart';
import 'package:hafiz_app/data/datasource/surah/surah_local_data_source.dart';
import 'package:hafiz_app/data/datasource/surah/surah_remote_data_source.dart';
import 'package:hafiz_app/data/repository/surah/surah_repository_impl.dart';
import 'package:hafiz_app/domain/repository/surah/surah_repository.dart';
import 'package:hafiz_app/domain/usecase/getsurah/get_surah.dart';
import 'package:hafiz_app/presentation/home_screen/provider/home_provider.dart';
import 'package:hafiz_app/presentation/surah_screen/provider/surah_provider.dart';

import 'core/network/network_manager.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /**
   * ! Features
   */
  // Bloc
  sl.registerLazySingleton(() => SurahStateNotifier(getSurah: sl()));
  sl.registerLazySingleton(() => HomeProvider());
  sl.registerLazySingleton(() => ThemeBloc());

  // Use Case
  sl.registerLazySingleton(() => GetSurah(surahRepository: sl()));

  // Repository
  sl.registerLazySingleton<SurahRepository>(() =>
      SurahRepositoryImpl(surahRemoteDataSource: sl(),surahLocalDataSource: sl(), networkInfo: sl()));

  // Data Source
  sl.registerLazySingleton<SurahRemoteDataSource>(() =>
      SurahRemoteDataSourceImpl(networkManager: NetworkManagerImpl(sl())));

  sl.registerLazySingleton<SurahLocalDataSource>(
      () => SurahLocalDataSourceImpl(databaseHelper: DatabaseHelper()));

  sl.registerLazySingleton(() => NetworkInfo(Connectivity()));

  /**
   * ! External
   */
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.baseUrl = "https://cdn.jsdelivr.net/gh/fawazahmed0/quran-api@1";
    return dio;
  });
}
