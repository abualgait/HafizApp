import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hafiz_app/injection_container.dart' as di;

import 'core/app_export.dart';
import 'injection_container.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:async';
import 'dart:ui' as ui;

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
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
    backgroundColor: Colors.indigo,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
    titleLarge: TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 16.0, color: Colors.white),
  ),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BootstrapApp());
}

Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  ThemeData _getTheme(BuildContext context) {
    return PrefUtils().getIsDarkMode() == true ? darkTheme : lightTheme;
  }

  final themeBloc = sl<ThemeBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => themeBloc,
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            theme: _getTheme(context),
            locale: const Locale('ar', 'EG'),
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
    );
  }
}

class BootstrapApp extends StatefulWidget {
  const BootstrapApp({super.key});

  @override
  State<BootstrapApp> createState() => _BootstrapAppState();
}

class _BootstrapAppState extends State<BootstrapApp> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await initFirebase();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await PrefUtils().init();
    await di.init();

    // Initialize Hive and open cache box for repository caching
    await Hive.initFlutter();
    await Hive.openBox('surah_cache');

    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(
        (await getApplicationDocumentsDirectory()).path,
      ),
    );

    // Wire Crashlytics for Flutter & platform errors
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    ui.PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    // Log app open for Analytics
    unawaited(FirebaseAnalytics.instance.logAppOpen());

    if (mounted) {
      setState(() => _ready = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) return MyApp();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor:
            PrefUtils().getIsDarkMode() ? Colors.black : Colors.white,
        body: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
