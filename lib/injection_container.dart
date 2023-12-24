import 'package:get_it/get_it.dart';
import 'package:hafiz_app/core/app_export.dart';
import 'package:hafiz_app/data/datasource/surah/surah_remote_data_source.dart';
import 'package:hafiz_app/data/repository/surah/surah_repository_impl.dart';
import 'package:hafiz_app/domain/repository/surah/surah_repository.dart';
import 'package:hafiz_app/domain/usecase/getsurah/get_surah.dart';
import 'package:hafiz_app/presentation/home_screen/bloc/home_bloc.dart';
import 'package:hafiz_app/presentation/surah_screen/bloc/surah_bloc.dart';

import 'core/network/network_manager.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /**
   * ! Features
   */
  // Bloc
  sl.registerFactory(() => SurahBloc(getSurah: sl()));
  sl.registerFactory(() => HomeBloc());
  sl.registerLazySingleton(() => ThemeBloc());

  // Use Case
  sl.registerLazySingleton(() => GetSurah(surahRepository: sl()));

  // Repository
  sl.registerLazySingleton<SurahRepository>(() => SurahRepositoryImpl(
      surahRemoteDataSource: sl(), networkInfo: NetworkInfo()));

  // Data Source
  sl.registerLazySingleton<SurahRemoteDataSource>(
      () => SurahRemoteDataSourceImpl(networkManager: NetworkManagerImpl()));
}
