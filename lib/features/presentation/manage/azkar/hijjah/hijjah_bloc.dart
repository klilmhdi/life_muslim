import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:quran_life_muslim/features/data/models/azkar/hijjah_model.dart';

part 'hijjah_event.dart';
part 'hijjah_state.dart';

class HijjahBloc extends Bloc<HijjahEvent, HijjahState> {
  HijjahBloc() : super(HijjahInitial()) {
      on<LoadHijjah>(_onLoadAzkar);
  }

  Future<void> _onLoadAzkar(LoadHijjah event, Emitter<HijjahState> emit) async {
    emit(HijjahLoading());
    try {
      final String response = await rootBundle.loadString('assets/json/dhu_al_hijjah.json');
      final List<dynamic> jsonData = json.decode(response);
      final List<HijjahModel> azkarList = jsonData.map((item) => HijjahModel.fromJson(item)).toList();

      emit(HijjahLoaded(azkarList));
    } catch (e, s) {
      print("Error: $e");
      print("StackTrace: $s");
      emit(HijjahError("Failed to load Azkar data"));
    }
  }
}
