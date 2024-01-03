import 'package:flutter/widgets.dart';

import '../../../core/quran_index/quran_surah.dart';
import '../../../core/utils/pref_utils.dart';

class HomeProvider extends ChangeNotifier {
  Surah? surah = PrefUtils().getLastReadSurah();

  void showLastSurah() {
    surah = PrefUtils().getLastReadSurah();
    notifyListeners();
  }
}
