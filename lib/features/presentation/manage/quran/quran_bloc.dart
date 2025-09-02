import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:quran_life_muslim/features/data/models/quran/quran_model.dart';

part 'quran_event.dart';
part 'quran_state.dart';

class QuranBloc extends HydratedBloc<QuranEvent, QuranState> {
  QuranBloc() : super(QuranInitial()) {
    on<LoadQuran>(_onLoadQuran);
  }

  QuranModel? _cachedQuran;

  Future<void> _onLoadQuran(LoadQuran event, Emitter<QuranState> emit) async {
    // ✅ لو الكاش مش فاضي رجّعه
    if (_cachedQuran != null) {
      emit(QuranLoaded(_cachedQuran!));
      return;
    }

    emit(QuranLoading());
    try {
      final String response =
      await rootBundle.loadString('assets/json/quran.json');
      final data = json.decode(response);

      if (!data.containsKey('data') || !data['data'].containsKey('surahs')) {
        throw Exception("Invalid JSON format: Missing 'data.surahs'");
      }

      final surahs = data['data']['surahs'] as List;

      QuranModel quranData;
      if (surahs.any((s) => (s['ayahs'] as List).length > 20)) {
        quranData = await compute<Map<String, dynamic>, QuranModel>(
          _parseQuranData,
          data as Map<String, dynamic>,
        );
      } else {
        quranData = QuranModel.fromJson(data);
      }

      // ✅ خزّن النتيجة في الكاش الداخلي + Hydrated Storage
      _cachedQuran = quranData;
      emit(QuranLoaded(quranData));
    } catch (e) {
      emit(QuranError("Failed to load Quran data: $e"));
    }
  }

  /// ✅ HydratedBloc serialization
  @override
  QuranState? fromJson(Map<String, dynamic> json) {
    try {
      final model = QuranModel.fromJson(json);
      _cachedQuran = model;
      return QuranLoaded(model);
    } catch (_) {
      return QuranInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(QuranState state) {
    if (state is QuranLoaded) {
      return state.quranData.toJson();
    }
    return null;
  }
}

/// لازم تكون Top-Level
QuranModel _parseQuranData(Map<String, dynamic> json) {
  return QuranModel.fromJson(json);
}
