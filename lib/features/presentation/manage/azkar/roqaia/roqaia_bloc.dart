import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:quran_life_muslim/features/data/models/azkar/azkar_model.dart';

import '../../../../data/models/azkar/quran_azkar_model.dart';
import '../../../../data/models/azkar/roqaia_model.dart';

part 'roqaia_event.dart';
part 'roqaia_state.dart';

class RoqaiaBloc extends Bloc<RoqaiaEvent, RoqaiaState> {
  RoqaiaBloc() : super(RoqaiaInitial()) {
      on<LoadRoqaia>(_onLoadAzkar);
  }

  Future<void> _onLoadAzkar(LoadRoqaia event, Emitter<RoqaiaState> emit) async {
    emit(RoqaiaLoading());
    try {
      final String response = await rootBundle.loadString('assets/json/roqaia.json');
      final List<dynamic> jsonData = json.decode(response);
      final List<RoqaiaModel> azkarList = jsonData.map((item) => RoqaiaModel.fromJson(item)).toList();

      emit(RoqaiaLoaded(azkarList));
    } catch (e, s) {
      print("Error: $e");
      print("StackTrace: $s");
      emit(RoqaiaError("Failed to load Azkar data"));
    }
  }
}
