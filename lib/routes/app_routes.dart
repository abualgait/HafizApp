import 'package:flutter/material.dart';
import 'package:hafiz_app/presentation/surah_screen/surah_screen.dart';

import '../presentation/home_screen/home_screen.dart';
import '../presentation/onboarding_screen/onboarding_screen.dart';
import '../presentation/about_screen/about_screen.dart';

class AppRoutes {
  static const String onboardingScreen = '/OnboardingScreen';
  static const String homePage = '/home_screen';
  static const String surahPage = '/surah_screen';
  static const String aboutPage = '/about_screen';

  static Map<String, WidgetBuilder> get routes => {
        onboardingScreen: OnboardingScreen.builder,
        homePage: (context) => const HomeScreen(),
        surahPage: (context) => const SurahScreen(),
        aboutPage: (context) => const AboutScreen(),
      };
}
