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
import 'core/i18n/locale_controller.dart';
import 'core/analytics/analytics_route_observer.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF006754), // deep green accent
    brightness: Brightness.light,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
    },
  ),
  appBarTheme: const AppBarTheme(centerTitle: true),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF87D1A4), // soft green tint for dark
    brightness: Brightness.dark,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
    },
  ),
  appBarTheme: const AppBarTheme(centerTitle: true),
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
          return ValueListenableBuilder<Locale>(
            valueListenable: LocaleController.notifier,
            builder: (_, locale, __) => MaterialApp(
              theme: _getTheme(context),
              locale: locale,
              title: 'Hafiz',
              navigatorKey: NavigatorService.navigatorKey,
              scaffoldMessengerKey: globalMessengerKey,
              navigatorObservers: [sl<AnalyticsRouteObserver>()],
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
            ),
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
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // Fire and forget prefs; default values are handled defensively
    unawaited(PrefUtils().init());
    await di.init();

    // Build Hydrated storage using a fast temp directory with a short soft-timeout
    final storageFuture = HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(
        (await getTemporaryDirectory()).path,
      ),
    );
    final softTimeout = Future.delayed(const Duration(milliseconds: 700));
    await Future.any([storageFuture, softTimeout]);
    storageFuture.then((s) => HydratedBloc.storage = s);

    // Defer heavier services to avoid long splash times
    unawaited(_postInitHeavyTasks());

    if (mounted) {
      setState(() => _ready = true);
    }
  }

  Future<void> _postInitHeavyTasks() async {
    try {
      await initFirebase();
      // Initialize Hive cache
      await Hive.initFlutter();
      await Hive.openBox('surah_cache');
      // Crashlytics wiring
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      ui.PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
      // Analytics
      unawaited(FirebaseAnalytics.instance.logAppOpen());
    } catch (_) {
      // Best-effort; app should remain usable regardless
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: _ready
          ? const _ReadyApp()
          : const _SplashScaffold(),
    );
  }
}

class _ReadyApp extends StatelessWidget {
  const _ReadyApp();
  @override
  Widget build(BuildContext context) => MyApp();
}

class _SplashScaffold extends StatelessWidget {
  const _SplashScaffold();
  @override
  Widget build(BuildContext context) {
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
