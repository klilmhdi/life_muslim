part of 'prayer_timings_by_today_bloc.dart';

abstract class PrayerTimingsEvent extends Equatable {
  const PrayerTimingsEvent();

  @override
  List<Object> get props => [];
}

class FetchPrayerTimings extends PrayerTimingsEvent {
  final double latitude;
  final double longitude;

  const FetchPrayerTimings({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

class ScheduleNotificationsIfEnabled extends PrayerTimingsEvent {
  final Map<String, String> prayerTimes;
  final TodayPrayerTimingsModel? timingsModel;

  const ScheduleNotificationsIfEnabled(this.prayerTimes, {this.timingsModel});

  @override
  List<Object> get props => [prayerTimes, timingsModel ?? ''];
}

class DisablePrayerNotifications extends PrayerTimingsEvent {}
