import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart';
import 'package:quran_life_muslim/features/data/models/quran/ayah_model.dart';
import 'package:quran_life_muslim/features/data/models/quran/quran_model.dart';
import 'package:quran_life_muslim/features/data/models/quran/surah_model.dart';

part 'quran_event.dart';
part 'quran_state.dart';

class QuranBloc extends Bloc<QuranEvent, QuranState> {
  QuranBloc() : super(QuranInitial()) {
    on<LoadQuran>(_onLoadQuran);
  }

  Future<void> _onLoadQuran(LoadQuran event, Emitter<QuranState> emit) async {
    emit(QuranLoading());
    try {
      final String response = await rootBundle.loadString('assets/json/quran.json');
      final data = json.decode(response);

      if (!data.containsKey('data') || !data['data'].containsKey('surahs')) {
        throw Exception("Invalid JSON format: Missing 'data.surahs'");
      }

      final quranData = QuranModel.fromJson(data);
      emit(QuranLoaded(quranData));
    } catch (e) {
      emit(QuranError("Failed to load Quran data"));
    }
  }
}
// import 'dart:convert';
//
// import 'package:bloc/bloc.dart';
// import 'package:flutter/services.dart';
// import 'package:quran_life_muslim/core/shared_preferenced/shared_preferenced.dart';
//
// import '../../../data/models/quran/ayah_model.dart';
// import '../../../data/models/quran/quran_model.dart';
// import '../../../data/models/quran/surah_model.dart';
//
// part 'quran_event.dart';
//
// part 'quran_state.dart';
//
// class QuranBloc extends Bloc<QuranEvent, QuranState> {
//   QuranBloc() : super(QuranInitial()) {
//     on<LoadQuran>(_onLoadQuran);
//     on<SaveBookmark>(_onSaveBookmark);
//   }
//
//   Future<void> _onLoadQuran(LoadQuran event, Emitter<QuranState> emit) async {
//     emit(QuranLoading());
//     try {
//       final String response = await rootBundle.loadString('assets/json/quran.json');
//       final data = json.decode(response);
//
//       if (!data.containsKey('data') || !data['data'].containsKey('surahs')) {
//         throw Exception("Invalid JSON format: Missing 'data.surahs'");
//       }
//
//       final quranData = QuranModel.fromJson(data);
//       emit(QuranLoaded(quranData));
//     } catch (e, s) {
//       print("Error: $e");
//       print("StackTrace: $s");
//       emit(QuranError("Failed to load Quran data"));
//     }
//   }
//
//   Future<void> _onSaveBookmark(SaveBookmark event, Emitter<QuranState> emit) async {
//     try {
//       await SharedPrefController.saveBookmark(
//         quranModel: event.quranModel,
//         surahName: event.surahName,
//         ayahs: event.ayahs,
//         selectedAyah: event.selectedAyah,
//       );
//       emit(BookmarkSaved());
//     } catch (e) {
//       print("Bookmark error: $e");
//       emit(QuranError("Failed to save bookmark"));
//     }
//   }
// }
