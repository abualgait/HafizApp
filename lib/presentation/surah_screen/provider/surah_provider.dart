import 'package:hafiz_app/domain/usecase/getsurah/get_surah.dart';
import 'package:riverpod/riverpod.dart';

import '../../../core/errors/failures.dart';
import '../../../data/model/surah_response.dart';
import '../../../injection_container.dart';

final surahStateProvider =
    StateNotifierProvider<SurahStateNotifier, SurahUIStates>((ref) {
  return SurahStateNotifier(getSurah: sl());
});

class SurahStateNotifier extends StateNotifier<SurahUIStates> {
  final GetSurah getSurah;

  SurahStateNotifier({required this.getSurah}) : super(SurahUIStates());

  void loadSurah(String surahId) async {
    state = SurahUIStates(isLoading: true);
    var response = await getSurah(ParamsGetSurah(surahId: surahId));
    response.fold(
      (failure) {
        if (failure is ServerFailure) {
          state = SurahUIStates(isLoading: false, error: failure.errorMessage);
        } else if (failure is ConnectionFailure) {
          state = SurahUIStates(isLoading: false, error: failure.errorMessage);
        }
      },
      (data) {
        state = SurahUIStates(isLoading: false, chapters: data.chapters);
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
