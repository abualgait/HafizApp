import 'package:hydrated_bloc/hydrated_bloc.dart';

class ScrollPositionCubit extends HydratedCubit<Map<String, double>> {
  ScrollPositionCubit() : super(const {});

  void saveOffset(String key, double offset) {
    // Minor debounce/capping could be added if needed
    final newState = Map<String, double>.from(state);
    newState[key] = offset;
    emit(newState);
  }

  double? getOffset(String key) => state[key];

  @override
  Map<String, double>? fromJson(Map<String, dynamic> json) {
    return json.map((k, v) => MapEntry(k, (v as num).toDouble()));
  }

  @override
  Map<String, dynamic>? toJson(Map<String, double> state) => state;
}

