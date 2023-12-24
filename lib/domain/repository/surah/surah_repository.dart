import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import '../../../data/model/surah_response.dart';

abstract class SurahRepository {
  Future<Either<Failure, ChapterResponse>> getSurah(String surahId);
}
