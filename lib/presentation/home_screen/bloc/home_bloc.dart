import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_app/core/quran_index/quran_surah.dart';

import '/core/app_export.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc()
      : super(UpdateLastReadSurah(surah: PrefUtils().getLastReadSurah())) {
    on<HomeEvent>(_onEvent);
  }

  Future<void> _onEvent(
    HomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (event is HomeShowLastSurahEvent) {
      emit(InitialSurahState());
      emit(UpdateLastReadSurah(surah: PrefUtils().getLastReadSurah()));
    }
  }
}
