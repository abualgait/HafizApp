import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:hafiz_app/injection_container.dart' as di;
import 'package:hafiz_app/presentation/home_screen/provider/home_provider.dart';
import 'package:hafiz_app/presentation/surah_screen/provider/surah_provider.dart';
import 'package:provider/provider.dart';

import 'core/app_export.dart';
import 'injection_container.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    color: Colors.blue,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16.0),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.indigo,
  scaffoldBackgroundColor: Colors.grey[900],
  appBarTheme: const AppBarTheme(
    color: Colors.indigo,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
    titleLarge: TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 16.0, color: Colors.white),
  ),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Future.wait([
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]),
    PrefUtils().init(),
    di.init()
  ]).then((value) {
    runApp(riverpod.ProviderScope(child: MyApp()));
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  ThemeData _getTheme(BuildContext context) {
    return PrefUtils().getIsDarkMode() == true ? darkTheme : lightTheme;
  }

  final themeBloc = sl<ThemeBloc>();
  final surahProvider = sl<SurahStateNotifier>();
  final homeProvider = sl<HomeProvider>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => homeProvider)],
      child: BlocProvider(
        create: (context) => themeBloc,
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              theme: _getTheme(context),
              title: 'Hafiz',
              navigatorKey: NavigatorService.navigatorKey,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                AppLocalizationDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale("en", "US"),
                Locale("ar", "EG"),
              ],
              initialRoute: AppRoutes.onboardingScreen,
              routes: AppRoutes.routes,
            );
          },
        ),
      ),
    );
  }
}
