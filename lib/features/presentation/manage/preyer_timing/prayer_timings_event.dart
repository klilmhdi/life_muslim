part of 'prayer_timings_bloc.dart';

abstract class PrayerTimingsEvent extends Equatable {
  const PrayerTimingsEvent();

  @override
  List<Object?> get props => [];
}

class FetchPrayerTimings extends PrayerTimingsEvent {
  final double latitude;
  final double longitude;

  const FetchPrayerTimings({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}
