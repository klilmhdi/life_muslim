import 'package:quran_life_muslim/features/data/models/quran/surah_model.dart';

import 'ayah_model.dart';

class AyahWithSurah {
  final SurahModel surah;
  final AyahsModel ayah;

  AyahWithSurah({required this.surah, required this.ayah});
}
