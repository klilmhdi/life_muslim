part of 'prayer_timings_by_today_bloc.dart';

// abstract class PrayerTimingsState extends Equatable {
//   final bool notificationsEnabled;
//
//   const PrayerTimingsState({this.notificationsEnabled = false});
//
//   @override
//   List<Object?> get props => [notificationsEnabled];
// }
abstract class PrayerTimingsState extends Equatable {
  final bool notificationsEnabled;
  final bool fridayNotificationEnabled;

  const PrayerTimingsState({
    this.notificationsEnabled = false,
    this.fridayNotificationEnabled = true,
  });

  @override
  List<Object?> get props => [notificationsEnabled, fridayNotificationEnabled];
}

class PrayerTimingsLoaded extends PrayerTimingsState {
  final TodayPrayerTimingsModel timings;

  const PrayerTimingsLoaded(
      this.timings, {
        bool notificationsEnabled = false,
        bool fridayNotificationEnabled = true,
      }) : super(
    notificationsEnabled: notificationsEnabled,
    fridayNotificationEnabled: fridayNotificationEnabled,
  );

  PrayerTimingsLoaded copyWith({
    TodayPrayerTimingsModel? timings,
    bool? notificationsEnabled,
    bool? fridayNotificationEnabled,
  }) {
    return PrayerTimingsLoaded(
      timings ?? this.timings,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      fridayNotificationEnabled: fridayNotificationEnabled ?? this.fridayNotificationEnabled,
    );
  }

  @override
  List<Object?> get props => [timings, notificationsEnabled, fridayNotificationEnabled];
}

class PrayerTimingsInitial extends PrayerTimingsState {}

class PrayerTimingsLoading extends PrayerTimingsState {}

// class PrayerTimingsLoaded extends PrayerTimingsState {
//   final TodayPrayerTimingsModel timings;
//
//   const PrayerTimingsLoaded(
//     this.timings, {
//     bool notificationsEnabled = false,
//   }) : super(notificationsEnabled: notificationsEnabled);
//
//   PrayerTimingsLoaded copyWith({
//     TodayPrayerTimingsModel? timings,
//     bool? notificationsEnabled,
//   }) {
//     return PrayerTimingsLoaded(
//       timings ?? this.timings,
//       notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
//     );
//   }
//
//   @override
//   List<Object?> get props => [timings, notificationsEnabled];
// }

class PrayerTimingsError extends PrayerTimingsState {
  final String message;

  const PrayerTimingsError(this.message) : super();

  @override
  List<Object?> get props => [message];
}