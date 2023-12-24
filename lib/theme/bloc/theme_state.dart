part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {}

class LightThemeState extends ThemeState {
  @override
  List<Object?> get props => ["light"];
}

class DarkThemeState extends ThemeState {
  @override
  List<Object?> get props => ["dark"];
}
