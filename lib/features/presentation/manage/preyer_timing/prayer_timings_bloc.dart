import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:quran_life_muslim/core/api/api.dart';
import 'package:quran_life_muslim/features/data/models/adhan/adhan_by_current_timer_model.dart';

part 'prayer_timings_event.dart';

part 'prayer_timings_state.dart';

class PrayerTimingsBloc extends Bloc<PrayerTimingsEvent, PrayerTimingsState> {
  PrayerTimingsBloc() : super(PrayerTimingsInitial()) {
    on<FetchPrayerTimings>(_onFetchPrayerTimings);
  }

  Future<void> _onFetchPrayerTimings(
      FetchPrayerTimings event, Emitter<PrayerTimingsState> emit) async {
    emit(PrayerTimingsLoading());

    try {
      final response = await http.get(Uri.parse(
        // 'https://api.aladhan.com/v1/timings/${_getFormattedDate()}?latitude=${event.latitude}&longitude=${event.longitude}&method=2',
        '${Api.aladhanByAddress}${_getFormattedDate()}?latitude=${event.latitude}&longitude=${event.longitude}&method=2',
      ));

      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (!data.containsKey('data') || !data['data'].containsKey('timings')) {
          throw Exception("Invalid JSON format: Missing 'data.timings'");
        }

        final timings = PrayerTimingsModel.fromJson(data['data']['timings']);
        emit(PrayerTimingsLoaded(timings));
      } else {
        emit(const PrayerTimingsError('Failed to load prayer timings'));
      }
    } catch (e, s) {
      print("Error: $e");
      print("StackTrace: $s");
      emit(PrayerTimingsError('Error: $e'));
    }
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    return '${now.day}-${now.month}-${now.year}';
  }
}
