part of 'theme_bloc.dart';

// Events
abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}
class OfflineEvent extends ThemeEvent {}
class OnlineEvent extends ThemeEvent {}