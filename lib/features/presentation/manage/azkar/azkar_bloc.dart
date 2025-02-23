import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:quran_life_muslim/features/data/models/azkar/azkar_model.dart';

part 'azkar_event.dart';
part 'azkar_state.dart';

class AzkarBloc extends Bloc<AzkarEvent, AzkarState> {
  AzkarBloc() : super(AzkarInitial()) {
      on<LoadAzkar>(_onLoadAzkar);
  }

  Future<void> _onLoadAzkar(LoadAzkar event, Emitter<AzkarState> emit) async {
    emit(AzkarLoading());
    try {
      final String response = await rootBundle.loadString('assets/json/adhkar.json');
      final List<dynamic> jsonData = json.decode(response); // ✅ تأكد أن `jsonData` هو List

      print("Loaded JSON: ${jsonData.toString()}");

      // ✅ تحويل قائمة JSON إلى قائمة من `AzkarModel`
      final List<AzkarModel> azkarList = jsonData.map((item) => AzkarModel.fromJson(item)).toList();

      emit(AzkarLoaded(azkarList)); // ✅ تمرير قائمة `AzkarModel` إلى الحالة
    } catch (e, s) {
      print("Error: $e");
      print("StackTrace: $s");
      emit(AzkarError("Failed to load Azkar data"));
    }
  }
}
