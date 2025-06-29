import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:quran_life_muslim/features/data/models/azkar/azkar_model.dart';

import '../../../../data/models/azkar/name_of_allah_model.dart';
import '../../../../data/models/azkar/quran_azkar_model.dart';

part 'name_of_allah_event.dart';
part 'name_of_allah_state.dart';

class NameOfAllahBloc extends Bloc<NameOfAllahEvent, NameOfAllahState> {
  NameOfAllahBloc() : super(NameOfAllahInitial()) {
      on<LoadNameOfAllah>(_onLoadAzkar);
  }

  Future<void> _onLoadAzkar(LoadNameOfAllah event, Emitter<NameOfAllahState> emit) async {
    emit(NameOfAllahLoading());
    try {
      final String response = await rootBundle.loadString('assets/json/name_of_allah.json');
      final List<dynamic> jsonData = json.decode(response);
      final List<NameOfAllahModel> azkarList = jsonData.map((item) => NameOfAllahModel.fromJson(item)).toList();

      emit(NameOfAllahLoaded(azkarList));
    } catch (e, s) {
      print("Error: $e");
      print("StackTrace: $s");
      emit(NameOfAllahError("Failed to load Azkar data"));
    }
  }
}
