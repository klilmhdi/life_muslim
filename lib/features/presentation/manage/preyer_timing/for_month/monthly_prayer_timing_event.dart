part of 'monthly_prayer_timing_bloc.dart';

abstract class MonthlyPrayerTimingEvent extends Equatable {
  const MonthlyPrayerTimingEvent();

  @override
  List<Object?> get props => [];
}

class FetchPrayerTimes extends MonthlyPrayerTimingEvent {
  final double lat;
  final double long;
  final int year;
  final int month;

  const FetchPrayerTimes({
    required this.lat,
    required this.long,
    required this.year,
    required this.month,
  });

  @override
  List<Object?> get props => [
        lat,
        long,
        year,
        month,
      ];
}
