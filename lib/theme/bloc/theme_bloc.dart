import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../core/app_export.dart';

part 'theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(PrefUtils().getIsDarkMode()
            ? DarkThemeState()
            : LightThemeState()) {
    on<ThemeEvent>(_changeTheme);
  }

  Future<void> _changeTheme(
    ThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    if (event is ToggleThemeEvent) {
      emit(PrefUtils().getIsDarkMode() ? LightThemeState() : DarkThemeState());
    }

    if (event is OfflineEvent) {
      emit(OfflineState());
    }

    if (event is OnlineEvent) {
      emit(OnlineState());
    }
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    final isDark = json['isDark'] as bool?;
    if (isDark == null) return null;
    return isDark ? DarkThemeState() : LightThemeState();
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {
      'isDark': state is DarkThemeState,
    };
  }
}
