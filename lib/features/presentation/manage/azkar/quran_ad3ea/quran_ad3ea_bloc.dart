import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:quran_life_muslim/features/data/models/azkar/azkar_model.dart';

import '../../../../data/models/azkar/quran_azkar_model.dart';

part 'quran_ad3ea_event.dart';
part 'quran_ad3ea_state.dart';

class QuranAzkarBloc extends Bloc<QuranAzkarEvent, QuranAzkarState> {
  QuranAzkarBloc() : super(QuranAzkarInitial()) {
      on<LoadQuranAzkar>(_onLoadAzkar);
  }

  Future<void> _onLoadAzkar(LoadQuranAzkar event, Emitter<QuranAzkarState> emit) async {
    emit(QuranAzkarLoading());
    try {
      final String response = await rootBundle.loadString('assets/json/adeaa_quran.json');
      final List<dynamic> jsonData = json.decode(response);
      final List<QuranAzkarModel> azkarList = jsonData.map((item) => QuranAzkarModel.fromJson(item)).toList();

      emit(QuranAzkarLoaded(azkarList));
    } catch (e, s) {
      print("Error: $e");
      print("StackTrace: $s");
      emit(QuranAzkarError("Failed to load Azkar data"));
    }
  }
}
