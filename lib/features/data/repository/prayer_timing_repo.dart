import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quran_life_muslim/core/utils/consts/app_consts.dart';
import 'package:quran_life_muslim/core/utils/functions/functions.dart';
import 'package:quran_life_muslim/features/data/models/adhan/azan_by_current_timer_model.dart';
import 'package:quran_life_muslim/features/data/models/adhan/azan_by_month_model.dart';

class PrayerTimingsRepository {
  /// Fetch today's prayer timings based on latitude and longitude
  Future<TodayPrayerTimingsModel> getTodayPrayerTimings({
    required double latitude,
    required double longitude,
  }) async {
    final url =
        '${AppConsts.todayAzanByAddress}${getFormattedDate()}?latitude=$latitude&longitude=$longitude';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (!data.containsKey('data') || !data['data'].containsKey('timings')) {
        throw Exception("Invalid JSON format: Missing 'data.timings'");
      }
      return TodayPrayerTimingsModel.fromJson(data['data']['timings']);
    } else {
      throw Exception('Failed to load today\'s prayer timings');
    }
  }

  /// Fetch monthly prayer timings based on city, country, and method
  Future<MontlyPrayerTimingsModel> getMonthlyPrayerTimings({
    required double lat,
    required double long,
    required int month,
    required int year,
  }) async {
    final url = '${AppConsts.fullAzanByAddress}/$year/$month?latitude=$lat&longitude=$long';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (!data.containsKey('data')) {
        throw Exception("Invalid JSON format: Missing 'data'");
      }
      return MontlyPrayerTimingsModel.fromJson(data);
    } else {
      throw Exception('Failed to load monthly prayer timings');
    }
  }
}
