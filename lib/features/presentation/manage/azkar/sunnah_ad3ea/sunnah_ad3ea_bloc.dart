import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:quran_life_muslim/features/data/models/azkar/azkar_model.dart';

import '../../../../data/models/azkar/quran_azkar_model.dart';
import '../../../../data/models/azkar/sunnah_azkar_model.dart';

part 'sunnah_ad3ea_event.dart';

part 'sunnah_ad3ea_state.dart';

class SunnahAzkarBloc extends Bloc<SunnahAzkarEvent, SunnahAzkarState> {
  SunnahAzkarBloc() : super(SunnahAzkarInitial()) {
    on<LoadSunnahAzkar>(_onLoadAzkar);
  }

  Future<void> _onLoadAzkar(LoadSunnahAzkar event, Emitter<SunnahAzkarState> emit) async {
    emit(SunnahAzkarLoading());
    try {
      final String response = await rootBundle.loadString('assets/json/adeaa_sunnah.json');
      final List<dynamic> jsonData = json.decode(response);
      final List<SunnahAzkarModel> azkarList =
          jsonData.map((item) => SunnahAzkarModel.fromJson(item)).toList();

      emit(SunnahAzkarLoaded(azkarList));
    } catch (e, s) {
      print("Error: $e");
      print("StackTrace: $s");
      emit(SunnahAzkarError("Failed to load Azkar data"));
    }
  }
}
