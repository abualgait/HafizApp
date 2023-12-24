import 'package:equatable/equatable.dart';

import '../../core/app_export.dart';

part 'theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(PrefUtils().getIsDarkMode() ? DarkThemeState() : LightThemeState()) {
    on<ThemeEvent>(_changeTheme);
  }

  _changeTheme(
    ThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    if (event is ToggleThemeEvent) {
      emit(PrefUtils().getIsDarkMode() ? LightThemeState() : DarkThemeState());
    }
  }
}
