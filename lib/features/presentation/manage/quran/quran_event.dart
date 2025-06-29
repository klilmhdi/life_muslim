// part of 'quran_bloc.dart';
//
// abstract class QuranEvent {}
//
// class LoadQuran extends QuranEvent {}
//
// class SaveBookmark extends QuranEvent {
//   final SurahModel quranModel;
//   final String surahName;
//   final List<AyahsModel> ayahs;
//   final AyahsModel selectedAyah;
//
//   SaveBookmark({
//     required this.quranModel,
//     required this.surahName,
//     required this.ayahs,
//     required this.selectedAyah,
//   });
// }
part of 'quran_bloc.dart';

abstract class QuranEvent {}

class LoadQuran extends QuranEvent {}