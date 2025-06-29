import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../../../../data/models/azkar/nawawi_model.dart';

part 'nawawi_event.dart';
part 'nawawi_state.dart';

class NawawiBloc extends Bloc<NawawiEvent, NawawiState> {
  NawawiBloc() : super(NawawiInitial()) {
      on<LoadNawawi>(_onLoadAzkar);
  }

  Future<void> _onLoadAzkar(LoadNawawi event, Emitter<NawawiState> emit) async {
    emit(NawawiLoading());
    try {
      final String response = await rootBundle.loadString('assets/json/40-hadith-nawawi.json');
      final List<dynamic> jsonData = json.decode(response);
      final List<NawawiModel> azkarList = jsonData.map((item) => NawawiModel.fromJson(item)).toList();

      emit(NawawiLoaded(azkarList));
    } catch (e, s) {
      print("Error: $e");
      print("StackTrace: $s");
      emit(NawawiError("Failed to load Azkar data"));
    }
  }
}
