import 'package:equatable/equatable.dart';

class TodayPrayerTimingsModel extends Equatable {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  const TodayPrayerTimingsModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory TodayPrayerTimingsModel.fromJson(Map<String, dynamic> json) {
    return TodayPrayerTimingsModel(
      fajr: json['Fajr'],
      sunrise: json['Sunrise'],
      dhuhr: json['Dhuhr'],
      asr: json['Asr'],
      maghrib: json['Maghrib'],
      isha: json['Isha'],
    );
  }

  @override
  List<Object?> get props => [fajr, sunrise, dhuhr, asr, maghrib, isha];
}
