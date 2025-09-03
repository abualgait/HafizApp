import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hafiz_app/core/app_export.dart';
import 'package:hafiz_app/data/datasource/surah/surah_remote_data_source.dart';
import 'package:hafiz_app/data/repository/surah/surah_repository_impl.dart';
import 'package:hafiz_app/domain/repository/surah/surah_repository.dart';
import 'package:hafiz_app/domain/usecase/getsurah/get_surah.dart';
import 'package:hafiz_app/presentation/home_screen/bloc/home_bloc.dart';
import 'package:hafiz_app/presentation/surah_screen/bloc/surah_bloc.dart';
import 'package:hafiz_app/data/datasource/surah/surah_local_data_source.dart';

import 'core/network/network_manager.dart';
import 'core/network/qf_auth.dart';
import 'core/config/api_config.dart';
import 'core/scroll/scroll_position_cubit.dart';
import 'core/analytics/analytics_service.dart';
import 'core/analytics/analytics_route_observer.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Local storage for caching is initialized in main() to avoid test issues.
  /**
   * ! Features
   */
  // Bloc
  sl.registerFactory(() => SurahBloc(getSurah: sl()));
  sl.registerFactory(() => HomeBloc());
  sl.registerLazySingleton(() => ThemeBloc());
  sl.registerLazySingleton(() => ScrollPositionCubit());
  // Defer Analytics creation until Firebase initializes; resolve inside observer when needed
  sl.registerLazySingleton(() => AnalyticsService());
  sl.registerLazySingleton(() => AnalyticsRouteObserver());

  // Use Case
  sl.registerLazySingleton(() => GetSurah(surahRepository: sl()));

  // Repository
  sl.registerLazySingleton<SurahRepository>(() =>
      SurahRepositoryImpl(
          surahRemoteDataSource: sl(),
          surahLocalDataSource: sl(),
          networkInfo: sl()));

  // Data Source
  sl.registerLazySingleton<SurahRemoteDataSource>(() =>
      SurahRemoteDataSourceImpl(networkManager: NetworkManagerImpl(sl())));
  sl.registerLazySingleton<SurahLocalDataSource>(
      () => SurahLocalDataSourceImpl());

  sl.registerLazySingleton(() => NetworkInfo(Connectivity()));

  /**
   * ! External
   */
  sl.registerLazySingleton(() {
    final dio = Dio();
    // Select base URL
    if (ApiConfig.useQfContent) {
      dio.options.baseUrl = ApiConfig.qfContentBase;
    } else {
      dio.options.baseUrl = "https://api.quran.com/api/v4";
    }
    dio.options.connectTimeout = const Duration(seconds: 7);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    // Attach Quran.Foundation OAuth2 interceptor if credentials provided
    if (ApiConfig.clientId.isNotEmpty && ApiConfig.clientSecret.isNotEmpty) {
      final auth = QfAuthService();
      dio.interceptors.add(QfAuthInterceptor(auth));
    }
    return dio;
  });
}
