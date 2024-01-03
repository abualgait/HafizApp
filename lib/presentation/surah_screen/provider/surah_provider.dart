import 'package:flutter/material.dart';
import 'package:hafiz_app/domain/usecase/getsurah/get_surah.dart';

import '../../../core/errors/failures.dart';
import '../../../data/model/surah_response.dart';

class SurahProvider extends ChangeNotifier {
  final GetSurah getSurah;

  SurahProvider({required this.getSurah});

  SurahUIStates? surahStates = SurahUIStates();

  void loadSurah(String surahId) async {
    surahStates = surahStates?.copyWith(isLoading: true);
    notifyListeners();
    var response = await getSurah(ParamsGetSurah(surahId: surahId));
    response.fold(
      (failure) {
        if (failure is ServerFailure) {
          surahStates = surahStates?.copyWith(
              error: failure.errorMessage, isLoading: false);
          notifyListeners();
        } else if (failure is ConnectionFailure) {
          surahStates = surahStates?.copyWith(
              error: failure.errorMessage, isLoading: false);
          notifyListeners();
        }
      },
      (data) {
        surahStates =
            surahStates?.copyWith(chapters: data.chapters, isLoading: false);
        notifyListeners();
      },
    );
  }
}

class SurahUIStates {
  bool isLoading;
  List<Chapter> chapters;
  String error;

  SurahUIStates({
    this.isLoading = false,
    this.chapters = const [],
    this.error = "",
  });

  SurahUIStates copyWith({
    bool? isLoading,
    List<Chapter>? chapters,
    String? error,
  }) {
    return SurahUIStates(
      isLoading: isLoading ?? this.isLoading,
      chapters: chapters ?? this.chapters,
      error: error ?? this.error,
    );
  }
}
