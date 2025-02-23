import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';

import '../../../data/models/quran/quran_model.dart';

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

      print("Loaded JSON: ${data.toString()}");

      final quranData = QuranModel.fromJson(data);
      emit(QuranLoaded(quranData));
    } catch (e, s) {
      print("Error: $e");
      print("StackTrace: $s");
      emit(QuranError("Failed to load Quran data"));
    }
  }
}