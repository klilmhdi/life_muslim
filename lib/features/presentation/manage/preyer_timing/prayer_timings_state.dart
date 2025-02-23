part of 'prayer_timings_bloc.dart';

abstract class PrayerTimingsState extends Equatable {
  const PrayerTimingsState();

  @override
  List<Object?> get props => [];
}

class PrayerTimingsInitial extends PrayerTimingsState {}

class PrayerTimingsLoading extends PrayerTimingsState {}

class PrayerTimingsLoaded extends PrayerTimingsState {
  final PrayerTimingsModel timings;

  const PrayerTimingsLoaded(this.timings);

  @override
  List<Object?> get props => [timings];
}

class PrayerTimingsError extends PrayerTimingsState {
  final String message;

  const PrayerTimingsError(this.message);

  @override
  List<Object?> get props => [message];
}
