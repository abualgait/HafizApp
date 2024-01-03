import 'package:flutter/material.dart';
import 'package:hafiz_app/presentation/surah_screen/surah_screen.dart';

import '../presentation/home_screen/home_screen.dart';
import '../presentation/onboarding_screen/onboarding_screen.dart';

class AppRoutes {
  static const String onboardingScreen = '/OnboardingScreen';
  static const String homePage = '/home_screen';
  static const String surahPage = '/surah_screen';

  static Map<String, WidgetBuilder> get routes => {
        onboardingScreen:  (context) => const OnboardingScreen(),
        homePage: (context) => const HomeScreen(),
        surahPage: (context) => const SurahScreen(),
      };
}
